// ConsumerDigitalAccountabilityProtocol.sol
pragma solidity ^0.8.0;

contract ConsumerDigitalAccountabilityProtocol {
    struct Rule {
        uint256 id;
        string safeguard;   // e.g. "Ensure Accountability in Consumer Digital Rights"
        string mechanism;   // e.g. "Mandate transparent reporting of ownership transfers and fair access policies"
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
