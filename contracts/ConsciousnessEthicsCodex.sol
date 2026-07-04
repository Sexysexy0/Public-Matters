pragma solidity ^0.8.20;

/// @title ConsciousnessEthicsCodex
/// @notice Encodes covenant for ethics of consciousness research.
/// @dev Anchors ethics, awareness, and safeguard rules.

contract ConsciousnessEthicsCodex {
    address public overseer;
    uint256 public codexCount;

    struct EthicsRule {
        uint256 id;
        string principle;   // Ethics, Awareness, Safeguard
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => EthicsRule> public rules;
    event EthicsRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareEthicsRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = EthicsRule(codexCount, principle, description, block.timestamp);
        emit EthicsRuleDeclared(codexCount, principle, description);
    }
}
