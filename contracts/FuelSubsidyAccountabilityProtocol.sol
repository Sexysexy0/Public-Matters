// FuelSubsidyAccountabilityProtocol.sol
pragma solidity ^0.8.0;

contract FuelSubsidyAccountabilityProtocol {
    struct Rule {
        uint256 id;
        string safeguard;   // e.g. "Accountability in Fuel Subsidy Governance"
        string mechanism;   // e.g. "Audit oil company discounts, enforce transparency in subsidy accounts, penalize exploitative fuel practices"
        uint256 timestamp;
    }

    uint256 public ruleCount;
    mapping(uint256 => Rule) public rules;

    event RuleLogged(uint256 id, string safeguard, string mechanism);

    function logRule(string memory safeguard, string memory mechanism) public {
        ruleCount++;
        rules[ruleCount] = Rule(ruleCount, safeguard, mechanism, block.timestamp);
        emit RuleLogged(ruleCount, safeguard, mechanism);
    }
}
