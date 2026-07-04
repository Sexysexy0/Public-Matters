pragma solidity ^0.8.20;

/// @title HumanEqualityCodex
/// @notice Encodes covenant for equality safeguards.
/// @dev Anchors equality, dignity, and safeguard rules.

contract HumanEqualityCodex {
    address public overseer;
    uint256 public codexCount;

    struct EqualityRule {
        uint256 id;
        string principle;   // Equality, Dignity, Safeguard
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => EqualityRule> public rules;
    event EqualityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareEqualityRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = EqualityRule(codexCount, principle, description, block.timestamp);
        emit EqualityRuleDeclared(codexCount, principle, description);
    }
}
