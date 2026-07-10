// SPDX-License-Identifier: MIT
// Contract Name: CodeOfConductEthicsPolicy
// Purpose: Establish clear standards of behavior and ethics in the workplace
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract CodeOfConductEthicsPolicy {
    address public chiefOperator;
    uint256 public policyCount;

    struct Policy {
        string principle;
        string guideline;
        uint256 timestamp;
    }

    Policy[] public policies;

    event PolicyAdded(string principle, string guideline, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        policyCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new conduct/ethics clause
    function addPolicy(string memory principle, string memory guideline) public onlyChief {
        policies.push(Policy(principle, guideline, block.timestamp));
        policyCount++;
        emit PolicyAdded(principle, guideline, block.timestamp);
    }

    // View conduct/ethics clause details
    function getPolicy(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < policies.length, "Invalid policy index");
        Policy memory p = policies[index];
        return (p.principle, p.guideline, p.timestamp);
    }
}
