// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title PublicSafetyMetricsRegistry
 * @notice Append-only record of public safety incidents and responses.
 *         Neutral: does not encode policy. Records what happened, when
 *         it was reported, when responders arrived, and how it ended.
 *
 * Citizens, journalists, and oversight bodies query response times,
 * incident rates, and outcome distributions per region and category.
 *
 * All identities are hashed off-chain. No PII on chain.
 */
contract PublicSafetyMetricsRegistry {
    OperatorPrivileges public immutable privileges;

    struct Incident {
        bytes32 id;
        bytes32 regionHash;
        bytes32 categoryHash;   // e.g. keccak("violent"), keccak("traffic")
        bytes32 outcomeHash;    // e.g. keccak("arrested"), keccak("cleared")
        uint256 reportedAt;
        uint256 respondedAt;
        uint256 resolvedAt;
        address recordedBy;
        bytes32 evidenceHash;
    }

    mapping(bytes32 => Incident) public incidents;
    bytes32[] public incidentIds;

    mapping(bytes32 => uint256) public incidentCountByRegion;
    mapping(bytes32 => uint256) public incidentCountByCategory;
    mapping(bytes32 => mapping(bytes32 => uint256)) public incidentCountByRegionAndCategory;
    mapping(bytes32 => uint256) public totalResponseTimeByRegion;   // seconds, sum
    mapping(bytes32 => uint256) public responseCountByRegion;
    mapping(bytes32 => uint256) public resolvedCountByRegion;

    uint256 public totalIncidents;
    uint256 public totalResponded;
    uint256 public totalResolved;

    event IncidentReported(
        bytes32 indexed id,
        bytes32 indexed regionHash,
        bytes32 indexed categoryHash,
        uint256 reportedAt,
        address recordedBy,
        bytes32 evidenceHash
    );
    event IncidentResponded(bytes32 indexed id, uint256 respondedAt);
    event IncidentResolved(bytes32 indexed id, uint256 resolvedAt, bytes32 outcomeHash);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function reportIncident(
        bytes32 regionHash,
        bytes32 categoryHash,
        bytes32 evidenceHash
    ) external onlyOperator returns (bytes32) {
        require(regionHash != bytes32(0), "regionHash=0");
        require(categoryHash != bytes32(0), "categoryHash=0");

        bytes32 id = keccak256(abi.encode(
            regionHash, categoryHash, msg.sender, block.timestamp, incidentIds.length
        ));
        require(incidents[id].reportedAt == 0, "Incident exists");

        incidents[id] = Incident({
            id: id,
            regionHash: regionHash,
            categoryHash: categoryHash,
            outcomeHash: bytes32(0),
            reportedAt: block.timestamp,
            respondedAt: 0,
            resolvedAt: 0,
            recordedBy: msg.sender,
            evidenceHash: evidenceHash
        });
        incidentIds.push(id);

        incidentCountByRegion[regionHash] += 1;
        incidentCountByCategory[categoryHash] += 1;
        incidentCountByRegionAndCategory[regionHash][categoryHash] += 1;
        totalIncidents += 1;

        emit IncidentReported(id, regionHash, categoryHash, block.timestamp, msg.sender, evidenceHash);
        return id;
    }

    function recordResponse(bytes32 id) external onlyOperator {
        Incident storage i = incidents[id];
        require(i.reportedAt != 0, "Incident not found");
        require(i.respondedAt == 0, "Already responded");
        i.respondedAt = block.timestamp;
        totalResponseTimeByRegion[i.regionHash] += (block.timestamp - i.reportedAt);
        responseCountByRegion[i.regionHash] += 1;
        totalResponded += 1;
        emit IncidentResponded(id, block.timestamp);
    }

    function recordResolution(bytes32 id, bytes32 outcomeHash) external onlyOperator {
        Incident storage i = incidents[id];
        require(i.reportedAt != 0, "Incident not found");
        require(i.resolvedAt == 0, "Already resolved");
        require(outcomeHash != bytes32(0), "outcomeHash=0");
        i.resolvedAt = block.timestamp;
        i.outcomeHash = outcomeHash;
        resolvedCountByRegion[i.regionHash] += 1;
        totalResolved += 1;
        emit IncidentResolved(id, block.timestamp, outcomeHash);
    }

    function getIncident(bytes32 id) external view returns (Incident memory) {
        return incidents[id];
    }

    function getIncidentCount() external view returns (uint256) {
        return incidentIds.length;
    }

    /// @notice Average response time for a region, in seconds. 0 when no responses.
    function getAverageResponseTime(bytes32 regionHash) external view returns (uint256) {
        uint256 n = responseCountByRegion[regionHash];
        if (n == 0) return 0;
        return totalResponseTimeByRegion[regionHash] / n;
    }

    function getRegionStats(bytes32 regionHash)
        external view returns (uint256 incidents_, uint256 responded_, uint256 resolved_)
    {
        return (
            incidentCountByRegion[regionHash],
            responseCountByRegion[regionHash],
            resolvedCountByRegion[regionHash]
        );
    }

    function getCategoryCount(bytes32 categoryHash) external view returns (uint256) {
        return incidentCountByCategory[categoryHash];
    }

    function getTotals()
        external view returns (uint256 incidents_, uint256 responded_, uint256 resolved_)
    {
        return (totalIncidents, totalResponded, totalResolved);
    }
}
