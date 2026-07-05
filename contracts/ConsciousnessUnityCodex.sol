pragma solidity ^0.8.20;

/// @title ConsciousnessUnityCodex
/// @notice Encodes covenant for unity of consciousness.
/// @dev Anchors unity, awareness, and safeguard rules.

contract ConsciousnessUnityCodex {
    address public overseer;
    uint256 public codexCount;

    struct UnityRule {
        uint256 id;
        string principle;   // Unity, Awareness, Safeguard
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => UnityRule> public rules;
    event UnityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareUnityRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = UnityRule(codexCount, principle, description, block.timestamp);
        emit UnityRuleDeclared(codexCount, principle, description);
    }
}
