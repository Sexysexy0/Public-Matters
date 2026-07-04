pragma solidity ^0.8.20;

/// @title FutureGenerationsCodex
/// @notice Encodes covenant for protecting future generations in AI era.
/// @dev Anchors sustainability, dignity, and resilience rules.

contract FutureGenerationsCodex {
    address public overseer;
    uint256 public codexCount;

    struct GenerationRule {
        uint256 id;
        string principle;   // Sustainability, Dignity, Resilience
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => GenerationRule> public rules;
    event GenerationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareGenerationRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = GenerationRule(codexCount, principle, description, block.timestamp);
        emit GenerationRuleDeclared(codexCount, principle, description);
    }
}
