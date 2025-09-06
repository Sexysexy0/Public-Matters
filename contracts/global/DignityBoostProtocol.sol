// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DignityBoostProtocol {
    address public steward;

    struct RoleFusion {
        string jobTitle;
        string sector;
        bool aiIntegrated;
        bool humanOversightRequired;
        uint256 dignityBoostLevel; // Scale: 0–100
        bool salaryEnhanced;
        uint256 timestamp;
    }

    RoleFusion[] public fusedRoles;

    event RoleFused(string jobTitle, string sector, uint256 dignityBoostLevel, bool salaryEnhanced, uint256 timestamp);
    event RoleRejected(string jobTitle, string reason, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function fuseRole(
        string memory jobTitle,
        string memory sector,
        bool aiIntegrated,
        bool humanOversightRequired,
        uint256 dignityBoostLevel,
        bool salaryEnhanced
    ) external onlySteward {
        require(aiIntegrated && humanOversightRequired, "Fusion criteria not met");
        fusedRoles.push(RoleFusion(jobTitle, sector, aiIntegrated, humanOversightRequired, dignityBoostLevel, salaryEnhanced, block.timestamp));
        emit RoleFused(jobTitle, sector, dignityBoostLevel, salaryEnhanced, block.timestamp);
    }

    function getFusedRole(uint256 index) external view returns (RoleFusion memory) {
        require(index < fusedRoles.length, "Index out of bounds");
        return fusedRoles[index];
    }

    function totalFusedRoles() external view returns (uint256) {
        return fusedRoles.length;
    }
}
