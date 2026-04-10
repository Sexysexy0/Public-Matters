// WhistleblowerEquityAccountabilityProtocol.sol
pragma solidity ^0.8.0;

contract WhistleblowerEquityAccountabilityProtocol {
    struct Rule {
        uint256 id;
        string safeguard;   // e.g. "Accountability in Whistleblower Justice"
        string mechanism;   // e.g. "Audit retaliation cases, enforce transparency in fraud exposure, penalize systemic suppression of whistleblowers"
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
