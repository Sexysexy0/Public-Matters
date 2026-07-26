// GlobalEnergyAccountabilityProtocol.sol
pragma solidity ^0.8.0;

contract GlobalEnergyAccountabilityProtocol {
    struct Rule {
        uint256 id;
        string safeguard;  // e.g. "Ensure transparency in global energy governance"
        string mechanism;  // e.g. "Independent Global Energy Oversight Council"
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
