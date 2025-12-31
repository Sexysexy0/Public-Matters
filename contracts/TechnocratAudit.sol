// contracts/TechnocratAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TechnocratAudit
 * @notice Logs audits of technocrat policies and their economic impact.
 */
contract TechnocratAudit {
    address public admin;

    struct Policy {
        string name;        // "MiguelCuaderno", "CentralBankStability"
        string impact;      // "JobLoss", "Underdevelopment"
        uint256 timestamp;
    }

    Policy[] public policies;

    event PolicyLogged(string name, string impact, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logPolicy(string calldata name, string calldata impact) external onlyAdmin {
        policies.push(Policy(name, impact, block.timestamp));
        emit PolicyLogged(name, impact, block.timestamp);
    }

    function totalPolicies() external view returns (uint256) { return policies.length; }

    function getPolicy(uint256 id) external view returns (Policy memory) {
        require(id < policies.length, "Invalid id");
        return policies[id];
    }
}
