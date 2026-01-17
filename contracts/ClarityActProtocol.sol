pragma solidity ^0.8.20;

contract ClarityActProtocol {
    address public admin;

    struct Rule {
        string regulator;    // e.g. SEC, CFTC
        string scope;        // e.g. securities, commodities
        uint256 timestamp;
    }

    Rule[] public rules;

    event RuleLogged(string regulator, string scope, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRule(string calldata regulator, string calldata scope) external onlyAdmin {
        rules.push(Rule(regulator, scope, block.timestamp));
        emit RuleLogged(regulator, scope, block.timestamp);
    }

    function totalRules() external view returns (uint256) {
        return rules.length;
    }
}
