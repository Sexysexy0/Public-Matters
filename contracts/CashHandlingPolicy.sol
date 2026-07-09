// SPDX-License-Identifier: MIT
// Contract Name: CashHandlingPolicy
// Purpose: Safeguard cash transactions and enforce accountability
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract CashHandlingPolicy {
    address public chiefOperator;
    uint256 public policyCount;

    struct Policy {
        string principle;
        string safeguardMechanism;
        uint256 timestamp;
    }

    Policy[] public policies;

    event PolicyAdded(string principle, string safeguardMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        policyCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new cash handling clause
    function addPolicy(string memory principle, string memory safeguardMechanism) public onlyChief {
        policies.push(Policy(principle, safeguardMechanism, block.timestamp));
        policyCount++;
        emit PolicyAdded(principle, safeguardMechanism, block.timestamp);
    }

    // View cash handling clause details
    function getPolicy(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < policies.length, "Invalid policy index");
        Policy memory p = policies[index];
        return (p.principle, p.safeguardMechanism, p.timestamp);
    }
}
