pragma solidity ^0.8.20;

contract SportsmanshipProtocol {
    address public admin;

    struct Rule {
        string description;  // e.g. headgear required, 3 rounds max
        string purpose;      // e.g. safety, fairness
        uint256 timestamp;
    }

    Rule[] public rules;

    event RuleLogged(string description, string purpose, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRule(string calldata description, string calldata purpose) external onlyAdmin {
        rules.push(Rule(description, purpose, block.timestamp));
        emit RuleLogged(description, purpose, block.timestamp);
    }

    function totalRules() external view returns (uint256) {
        return rules.length;
    }
}
