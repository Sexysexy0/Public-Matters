// contracts/DisasterAdaptation.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DisasterAdaptation
 * @notice Protocol for communal adaptation measures against disasters.
 */
contract DisasterAdaptation {
    address public admin;

    struct Plan {
        string hazard;      // "Typhoon", "Earthquake", "Flood"
        string description;
        string status;      // "Draft", "Active"
        uint256 timestamp;
    }

    Plan[] public plans;

    event PlanLogged(string hazard, string description, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logPlan(string calldata hazard, string calldata description, string calldata status) external onlyAdmin {
        plans.push(Plan(hazard, description, status, block.timestamp));
        emit PlanLogged(hazard, description, status, block.timestamp);
    }

    function totalPlans() external view returns (uint256) { return plans.length; }

    function getPlan(uint256 id) external view returns (Plan memory) {
        require(id < plans.length, "Invalid id");
        return plans[id];
    }
}
