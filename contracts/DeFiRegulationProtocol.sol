pragma solidity ^0.8.20;

contract DeFiRegulationProtocol {
    address public admin;

    struct Rule {
        string entity;       // e.g. centralized exchange, decentralized protocol
        string regulation;   // e.g. AML, BSA, exempt
        uint256 timestamp;
    }

    Rule[] public rules;

    event RuleLogged(string entity, string regulation, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRule(string calldata entity, string calldata regulation) external onlyAdmin {
        rules.push(Rule(entity, regulation, block.timestamp));
        emit RuleLogged(entity, regulation, block.timestamp);
    }

    function totalRules() external view returns (uint256) {
        return rules.length;
    }
}
