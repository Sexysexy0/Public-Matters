// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TaxSimplification
/// @notice Covenant contract to simplify tax rules and enforce fairness
contract TaxSimplification {
    address public owner;

    struct TaxRule {
        string name;
        uint256 rate;       // percentage
        uint256 threshold;  // income exempt threshold
        bool active;
    }

    mapping(string => TaxRule) public rules;

    event RuleCreated(string name, uint256 rate, uint256 threshold);
    event RuleUpdated(string name, uint256 rate, uint256 threshold);
    event RuleDeactivated(string name);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createRule(string memory name, uint256 rate, uint256 threshold) public onlyOwner {
        rules[name] = TaxRule(name, rate, threshold, true);
        emit RuleCreated(name, rate, threshold);
    }

    function updateRule(string memory name, uint256 rate, uint256 threshold) public onlyOwner {
        require(rules[name].active, "Rule not active");
        rules[name].rate = rate;
        rules[name].threshold = threshold;
        emit RuleUpdated(name, rate, threshold);
    }

    function deactivateRule(string memory name) public onlyOwner {
        require(rules[name].active, "Rule already inactive");
        rules[name].active = false;
        emit RuleDeactivated(name);
    }

    function isExempt(string memory name, uint256 income) public view returns (bool) {
        TaxRule memory rule = rules[name];
        return rule.active && income <= rule.threshold;
    }

    function calculateTax(string memory name, uint256 income) public view returns (uint256) {
        TaxRule memory rule = rules[name];
        if (!rule.active || income <= rule.threshold) {
            return 0;
        }
        return (income - rule.threshold) * rule.rate / 100;
    }
}
