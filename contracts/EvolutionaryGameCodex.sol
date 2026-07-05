pragma solidity ^0.8.20;

/// @title EvolutionaryGameCodex
/// @notice Encodes covenant for evolutionary game safeguards.
/// @dev Anchors adaptation, survival, and safeguard rules.

contract EvolutionaryGameCodex {
    address public overseer;
    uint256 public codexCount;

    struct GameRule {
        uint256 id;
        string principle;   // Adaptation, Survival, Safeguard
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => GameRule> public rules;
    event GameRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareGameRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = GameRule(codexCount, principle, description, block.timestamp);
        emit GameRuleDeclared(codexCount, principle, description);
    }
}
