pragma solidity ^0.8.20;

/// @title EthicalAwarenessCodex
/// @notice Covenant for ethical safeguards in awareness systems.
/// @dev Anchors moral clarity, communal fairness, dignity protocols.

contract EthicalAwarenessCodex {
    address public overseer;
    uint256 public codexCount;

    struct EthicalRule {
        uint256 id;
        string principle;   // Ethical Awareness, Moral Clarity, Fairness
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => EthicalRule) public rules;
    event EthicalRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareEthicalRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = EthicalRule(codexCount, principle, description, block.timestamp);
        emit EthicalRuleDeclared(codexCount, principle, description);
    }
}
