// contracts/HouseholdImpact.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title HouseholdImpact
 * @notice Logs household-level effects of economic slowdown (jobs, wages, poverty).
 */
contract HouseholdImpact {
    address public admin;

    struct Impact {
        string category;   // "Jobs", "Wages", "Poverty"
        string description;
        uint256 severity;  // scale 1-10
        uint256 timestamp;
    }

    Impact[] public impacts;

    event ImpactLogged(string category, string description, uint256 severity, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logImpact(string calldata category, string calldata description, uint256 severity) external onlyAdmin {
        impacts.push(Impact(category, description, severity, block.timestamp));
        emit ImpactLogged(category, description, severity, block.timestamp);
    }

    function totalImpacts() external view returns (uint256) { return impacts.length; }

    function getImpact(uint256 id) external view returns (Impact memory) {
        require(id < impacts.length, "Invalid id");
        return impacts[id];
    }
}
