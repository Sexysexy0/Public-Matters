// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivilegesV2.sol";

/**
 * @title AIAgentIncidentRegistry
 * @notice Public incident log for AI agent failures, attacks, and breaches.
 */
contract AIAgentIncidentRegistry {
    OperatorPrivilegesV2 public privileges;

    enum Severity { LOW, MEDIUM, HIGH, CRITICAL }
    enum Status { OPEN, RESOLVED, DISMISSED }

    struct Incident {
        uint256 id;
        bytes32 agentId;
        Severity severity;
        Status status;
        bytes32 incidentType;
        string description;
        string resolution;
        address reportedBy;
        uint256 reportedAt;
        uint256 resolvedAt;
        address resolvedBy;
    }

    uint256 public incidentCount;
    mapping(uint256 => Incident) internal _incidents;
    mapping(bytes32 => uint256[]) internal _incidentsByAgent;
    mapping(bytes32 => uint256) public incidentCountByType;

    event IncidentReported(
        uint256 indexed id,
        bytes32 indexed agentId,
        Severity severity,
        bytes32 incidentType,
        address reportedBy
    );
    event IncidentResolved(uint256 indexed id, string resolution, address resolvedBy);
    event IncidentDismissed(uint256 indexed id, address dismissedBy);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "Invalid privileges");
        privileges = OperatorPrivilegesV2(_privileges);
    }

    function reportIncident(
        bytes32 agentId,
        Severity severity,
        bytes32 incidentType,
        string calldata description
    ) external onlyOperator returns (uint256) {
        incidentCount++;
        uint256 id = incidentCount;

        _incidents[id] = Incident({
            id: id,
            agentId: agentId,
            severity: severity,
            status: Status.OPEN,
            incidentType: incidentType,
            description: description,
            resolution: "",
            reportedBy: msg.sender,
            reportedAt: block.timestamp,
            resolvedAt: 0,
            resolvedBy: address(0)
        });

        _incidentsByAgent[agentId].push(id);
        incidentCountByType[incidentType]++;

        emit IncidentReported(id, agentId, severity, incidentType, msg.sender);
        return id;
    }

    function resolveIncident(uint256 id, string calldata resolution) external onlyOperator {
        Incident storage i = _incidents[id];
        require(i.id != 0, "Incident not found");
        require(i.status == Status.OPEN, "Not open");

        i.status = Status.RESOLVED;
        i.resolution = resolution;
        i.resolvedAt = block.timestamp;
        i.resolvedBy = msg.sender;

        emit IncidentResolved(id, resolution, msg.sender);
    }

    function dismissIncident(uint256 id) external onlyOperator {
        Incident storage i = _incidents[id];
        require(i.id != 0, "Incident not found");
        require(i.status == Status.OPEN, "Not open");

        i.status = Status.DISMISSED;
        i.resolvedAt = block.timestamp;
        i.resolvedBy = msg.sender;

        emit IncidentDismissed(id, msg.sender);
    }

    function getIncident(uint256 id) external view returns (Incident memory) {
        return _incidents[id];
    }

    function getIncidentsByAgent(bytes32 agentId) external view returns (uint256[] memory) {
        return _incidentsByAgent[agentId];
    }

    function totalIncidents() external view returns (uint256) {
        return incidentCount;
    }
}
