// PrivacyProtocol.sol
pragma solidity ^0.8.0;

contract PrivacyProtocol {
    struct Rule {
        uint256 id;
        string domain;       // e.g. "User Data"
        string description;  // e.g. "Encrypt personal info"
        bool enforced;
        uint256 timestamp;
    }

    uint256 public ruleCount;
    mapping(uint256 => Rule) public rules;

    event RuleEnforced(uint256 id, string domain, string description);

    function enforceRule(string memory domain, string memory description) public {
        ruleCount++;
        rules[ruleCount] = Rule(ruleCount, domain, description, true, block.timestamp);
        emit RuleEnforced(ruleCount, domain, description);
    }
}
