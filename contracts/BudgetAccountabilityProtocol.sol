// BudgetAccountabilityProtocol.sol
pragma solidity ^0.8.0;

contract BudgetAccountabilityProtocol {
    struct Rule {
        uint256 id;
        string safeguard;   // e.g. "Transparency in Unprogrammed Appropriations"
        string mechanism;   // e.g. "Mandate SARO listings, require DBM certification of excess income, enforce audit trails"
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
