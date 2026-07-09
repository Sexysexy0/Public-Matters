// SPDX-License-Identifier: MIT
// Contract Name: CashIntegrityPolicy
// Purpose: Ensure transparency and integrity in cash flow
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract CashIntegrityPolicy {
    address public chiefOperator;
    uint256 public policyCount;

    struct Policy {
        string transactionType; // e.g., Salary, Bonus, Community Fund
        string integrityRule;   // e.g., Transparency log, Equal distribution
        string safeguard;       // e.g., Audit, Public ledger
        uint256 timestamp;
    }

    Policy[] public policies;

    event PolicyAdded(string transactionType, string integrityRule, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        policyCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new cash integrity policy
    function addPolicy(string memory transactionType, string memory integrityRule, string memory safeguard) public onlyChief {
        policies.push(Policy(transactionType, integrityRule, safeguard, block.timestamp));
        policyCount++;
        emit PolicyAdded(transactionType, integrityRule, safeguard, block.timestamp);
    }

    // View policy details
    function getPolicy(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < policies.length, "Invalid policy index");
        Policy memory p = policies[index];
        return (p.transactionType, p.integrityRule, p.safeguard, p.timestamp);
    }
}
