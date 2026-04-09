// BudgetTransparencyAccountabilityProtocol.sol
pragma solidity ^0.8.0;

contract BudgetTransparencyAccountabilityProtocol {
    struct Rule {
        uint256 id;
        string safeguard;   // e.g. "Accountability in Budget Transparency"
        string mechanism;   // e.g. "Mandate audits of SARO releases, enforce compliance with disclosure standards, penalize concealment of fiscal data"
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
