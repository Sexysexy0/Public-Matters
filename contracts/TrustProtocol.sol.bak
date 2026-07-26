// TrustProtocol.sol
pragma solidity ^0.8.0;

contract TrustProtocol {
    struct Rule {
        uint256 id;
        string clause;       // e.g. "No unverifiable narratives"
        bool enforced;
        uint256 timestamp;
    }

    uint256 public ruleCount;
    mapping(uint256 => Rule) public rules;

    event RuleEnforced(uint256 id, string clause);

    function enforceRule(string memory clause) public {
        ruleCount++;
        rules[ruleCount] = Rule(ruleCount, clause, true, block.timestamp);
        emit RuleEnforced(ruleCount, clause);
    }
}
