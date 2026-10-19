// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title EnergyProductionRegistry
 * @notice Append-only record of energy production by source and region.
 *         Neutral: does not encode policy. Records what was produced,
 *         at what cost, and where. Citizens, journalists, and regulators
 *         query the same numbers regardless of the governing platform.
 *
 * Sources are an open enum. Region is hashed off-chain so jurisdictions
 * can encode their own geography without changing the contract.
 */
contract EnergyProductionRegistry {
    OperatorPrivileges public immutable privileges;

    enum Source {
        OIL,
        GAS,
        NUCLEAR,
        SOLAR,
        WIND,
        HYDRO,
        COAL,
        OTHER
    }
    uint8 public constant SOURCE_COUNT = 8;

    struct ProductionRecord {
        bytes32 id;
        bytes32 regionHash;
        Source source;
        uint256 volume; // caller-defined unit (MWh, barrels, etc.)
        uint256 costPerUnit; // smallest currency unit
        address recordedBy;
        bytes32 evidenceHash;
        uint256 timestamp;
    }

    mapping(bytes32 => ProductionRecord) public records;
    bytes32[] public recordIds;

    mapping(uint8 => uint256) public totalVolumeBySource;
    mapping(uint8 => uint256) public totalCountBySource;
    mapping(bytes32 => uint256) public totalVolumeByRegion;
    mapping(bytes32 => mapping(uint8 => uint256)) public volumeByRegionAndSource;
    mapping(bytes32 => mapping(uint8 => uint256)) public costSumByRegionAndSource;
    mapping(bytes32 => mapping(uint8 => uint256)) public countByRegionAndSource;

    uint256 public totalVolume;

    event ProductionRecorded(
        bytes32 indexed id,
        bytes32 indexed regionHash,
        Source source,
        uint256 volume,
        uint256 costPerUnit,
        address recordedBy,
        bytes32 evidenceHash
    );

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function recordProduction(
        bytes32 regionHash,
        Source source,
        uint256 volume,
        uint256 costPerUnit,
        bytes32 evidenceHash
    ) external onlyOperator returns (bytes32) {
        require(regionHash != bytes32(0), "regionHash=0");
        require(volume > 0, "volume=0");

        bytes32 id = keccak256(
            abi.encode(regionHash, uint8(source), volume, costPerUnit, msg.sender, block.timestamp, recordIds.length)
        );
        require(records[id].timestamp == 0, "Record exists");

        records[id] = ProductionRecord({
            id: id,
            regionHash: regionHash,
            source: source,
            volume: volume,
            costPerUnit: costPerUnit,
            recordedBy: msg.sender,
            evidenceHash: evidenceHash,
            timestamp: block.timestamp
        });
        recordIds.push(id);

        uint8 s = uint8(source);
        totalVolumeBySource[s] += volume;
        totalCountBySource[s] += 1;
        totalVolumeByRegion[regionHash] += volume;
        volumeByRegionAndSource[regionHash][s] += volume;
        costSumByRegionAndSource[regionHash][s] += costPerUnit;
        countByRegionAndSource[regionHash][s] += 1;
        totalVolume += volume;

        emit ProductionRecorded(id, regionHash, source, volume, costPerUnit, msg.sender, evidenceHash);
        return id;
    }

    function getRecord(bytes32 id) external view returns (ProductionRecord memory) {
        return records[id];
    }

    function getRecordCount() external view returns (uint256) {
        return recordIds.length;
    }

    /// @notice Share of total volume from a given source, in bps (10000 = 100%).
    function getSourceShare(Source source) external view returns (uint256) {
        if (totalVolume == 0) return 0;
        return (totalVolumeBySource[uint8(source)] * 10000) / totalVolume;
    }

    /// @notice Average cost per unit for a source in a region.
    ///         Returns 0 when no records exist for the pair.
    function getAverageCost(bytes32 regionHash, Source source) external view returns (uint256) {
        uint256 count = countByRegionAndSource[regionHash][uint8(source)];
        if (count == 0) return 0;
        return costSumByRegionAndSource[regionHash][uint8(source)] / count;
    }

    function getSourceTotals(Source source) external view returns (uint256 volume, uint256 count) {
        uint8 s = uint8(source);
        return (totalVolumeBySource[s], totalCountBySource[s]);
    }

    function getRegionTotals(bytes32 regionHash) external view returns (uint256 volume, uint256 count) {
        return (
            totalVolumeByRegion[regionHash],
            countByRegionAndSource[regionHash][0] + countByRegionAndSource[regionHash][1]
                + countByRegionAndSource[regionHash][2] + countByRegionAndSource[regionHash][3]
                + countByRegionAndSource[regionHash][4] + countByRegionAndSource[regionHash][5]
                + countByRegionAndSource[regionHash][6] + countByRegionAndSource[regionHash][7]
        );
    }

    function getTotals() external view returns (uint256 volume) {
        return totalVolume;
    }
}
