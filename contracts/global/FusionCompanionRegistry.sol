// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract FusionCompanionRegistry {
    address public steward;

    struct FusionPair {
        string aiSystem;
        string humanRole;
        string sector;
        bool oversightRequired;
        bool emotionallyAligned;
        bool fusionCertified;
        uint256 timestamp;
    }

    FusionPair[] public registry;

    event FusionCertified(string aiSystem, string humanRole, string sector, uint256 timestamp);
    event FusionRevoked(string aiSystem, string reason, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function certifyFusion(
        string memory aiSystem,
        string memory humanRole,
        string memory sector,
        bool oversightRequired,
        bool emotionallyAligned
    ) external onlySteward {
        require(oversightRequired && emotionallyAligned, "Fusion criteria not met");
        registry.push(FusionPair(aiSystem, humanRole, sector, oversightRequired, emotionallyAligned, true, block.timestamp));
        emit FusionCertified(aiSystem, humanRole, sector, block.timestamp);
    }

    function revokeFusion(uint256 index, string memory reason) external onlySteward {
        require(index < registry.length, "Invalid index");
        registry[index].fusionCertified = false;
        emit FusionRevoked(registry[index].aiSystem, reason, block.timestamp);
    }

    function getFusionPair(uint256 index) external view returns (FusionPair memory) {
        require(index < registry.length, "Index out of bounds");
        return registry[index];
    }

    function totalFusions() external view returns (uint256) {
        return registry.length;
    }
}
