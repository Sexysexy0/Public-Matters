// SPDX-License-Identifier: MIT
// Contract Name: DigitalRightsFirewall
// Purpose: Safeguard against surveillance abuse, spyware, and AI-driven privacy threats
// Author: Vin (Chief Operator / Batman)

pragma solidity ^0.8.20;

contract DigitalRightsFirewall {
    address public chiefOperator;
    uint256 public ruleCount;

    struct Rule {
        string threat;
        string defenseMechanism;
        uint256 timestamp;
    }

    Rule[] public rules;

    event RuleAdded(string threat, string defenseMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        ruleCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new firewall rule
    function addRule(string memory threat, string memory defenseMechanism) public onlyChief {
        rules.push(Rule(threat, defenseMechanism, block.timestamp));
        ruleCount++;
        emit RuleAdded(threat, defenseMechanism, block.timestamp);
    }

    // View firewall rule details
    function getRule(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < rules.length, "Invalid rule index");
        Rule memory r = rules[index];
        return (r.threat, r.defenseMechanism, r.timestamp);
    }
}
