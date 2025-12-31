// contracts/MediaDignityProtocol.sol
pragma solidity ^0.8.20;

/**
 * @title MediaDignityProtocol
 * @notice Ensures validator-grade dignity in media practices and communal audit.
 */
contract MediaDignityProtocol {
    address public admin;

    struct Rule {
        string name;        // "Accuracy", "Fairness", "SolutionDriven"
        string description;
        string status;      // "Implemented", "Pending"
        uint256 timestamp;
    }

    Rule[] public rules;

    event RuleLogged(string name, string description, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }

    function logRule(string calldata name, string calldata description, string calldata status) external onlyAdmin {
        rules.push(Rule(name, description, status, block.timestamp));
        emit RuleLogged(name, description, status, block.timestamp);
    }
}
