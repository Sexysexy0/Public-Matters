// contracts/UniversalInsurance.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title UniversalInsurance
 * @notice Logs communal access to health insurance for all citizens.
 */
contract UniversalInsurance {
    address public admin;

    struct Policy {
        string beneficiary;   // "Comedian", "Freelancer", "Worker"
        string coverage;      // "Hospitalization", "Medicine", "PreventiveCare"
        string status;        // "Active", "Pending"
        uint256 timestamp;
    }

    Policy[] public policies;

    event PolicyLogged(string beneficiary, string coverage, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logPolicy(string calldata beneficiary, string calldata coverage, string calldata status) external onlyAdmin {
        policies.push(Policy(beneficiary, coverage, status, block.timestamp));
        emit PolicyLogged(beneficiary, coverage, status, block.timestamp);
    }

    function totalPolicies() external view returns (uint256) { return policies.length; }

    function getPolicy(uint256 id) external view returns (Policy memory) {
        require(id < policies.length, "Invalid id");
        return policies[id];
    }
}
