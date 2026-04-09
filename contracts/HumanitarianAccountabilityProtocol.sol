// HumanitarianAccountabilityProtocol.sol
pragma solidity ^0.8.0;

contract HumanitarianAccountabilityProtocol {
    struct Rule {
        uint256 id;
        string safeguard;   // e.g. "Accountability in Aid Delivery"
        string mechanism;   // e.g. "Audit donor funds, enforce compliance with relief standards, penalize diversion of humanitarian resources"
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
