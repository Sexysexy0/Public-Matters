// contracts/DigitalSovereignty.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DigitalSovereignty
 * @notice Ledger for communal sovereignty in digital domains.
 */
contract DigitalSovereignty {
    address public admin;

    struct Policy {
        string name;        // "DataCommons", "CyberDefense"
        string description;
        string status;      // "Active", "Draft"
        uint256 timestamp;
    }

    Policy[] public policies;

    event PolicyLogged(string name, string description, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logPolicy(string calldata name, string calldata description, string calldata status) external onlyAdmin {
        policies.push(Policy(name, description, status, block.timestamp));
        emit PolicyLogged(name, description, status, block.timestamp);
    }

    function totalPolicies() external view returns (uint256) { return policies.length; }

    function getPolicy(uint256 id) external view returns (Policy memory) {
        require(id < policies.length, "Invalid id");
        return policies[id];
    }
}
