pragma solidity ^0.8.20;

/// @title EvolutionaryAdaptationCodex
/// @notice Encodes covenant for adaptation safeguards.
/// @dev Anchors adaptation, survival, and safeguard rules.

contract EvolutionaryAdaptationCodex {
    address public overseer;
    uint256 public codexCount;

    struct AdaptationRule {
        uint256 id;
        string principle;   // Adaptation, Survival, Safeguard
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => AdaptationRule> public rules;
    event AdaptationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareAdaptationRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = AdaptationRule(codexCount, principle, description, block.timestamp);
        emit AdaptationRuleDeclared(codexCount, principle, description);
    }
}
