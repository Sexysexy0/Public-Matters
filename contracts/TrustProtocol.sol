// contracts/TrustProtocol.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TrustProtocol
 * @notice Ensures validator-grade communal trust in digital ecosystems.
 */
contract TrustProtocol {
    address public admin;

    struct Rule {
        string name;        // "Transparency", "IncidentDisclosure"
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

    function totalRules() external view returns (uint256) { return rules.length; }

    function getRule(uint256 id) external view returns (Rule memory) {
        require(id < rules.length, "Invalid id");
        return rules[id];
    }
}
