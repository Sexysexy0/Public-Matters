// contracts/RegulationAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RegulationAudit
 * @notice Tracks AI regulation status and communal dignity in governance.
 */
contract RegulationAudit {
    address public admin;

    struct Policy {
        string jurisdiction; // "US", "EU", "China"
        string status;       // "Unregulated", "Pending", "Active"
        string description;
        uint256 timestamp;
    }

    Policy[] public policies;

    event PolicyLogged(string jurisdiction, string status, string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logPolicy(string calldata jurisdiction, string calldata status, string calldata description) external onlyAdmin {
        policies.push(Policy(jurisdiction, status, description, block.timestamp));
        emit PolicyLogged(jurisdiction, status, description, block.timestamp);
    }

    function totalPolicies() external view returns (uint256) { return policies.length; }

    function getPolicy(uint256 id) external view returns (Policy memory) {
        require(id < policies.length, "Invalid id");
        return policies[id];
    }
}
