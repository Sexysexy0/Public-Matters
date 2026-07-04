pragma solidity ^0.8.20;

/// @title EthicalAICharter
/// @notice Encodes ethical AI governance rules.
/// @dev Anchors fairness, transparency, and accountability principles.

contract EthicalAICharter {
    address public overseer;
    uint256 public charterCount;

    struct EthicalRule {
        uint256 id;
        string principle;   // Fairness, Transparency, Accountability
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => EthicalRule> public rules;
    event EthicalRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareEthicalRule(string calldata principle, string calldata description) external onlyOverseer {
        charterCount++;
        rules[charterCount] = EthicalRule(charterCount, principle, description, block.timestamp);
        emit EthicalRuleDeclared(charterCount, principle, description);
    }
}
