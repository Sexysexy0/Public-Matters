pragma solidity ^0.8.20;

/// @title TrustOverrideCodex
/// @notice Encodes safeguards for human trust systems.
/// @dev Anchors override rights, transparency, and trust resilience.

contract TrustOverrideCodex {
    address public overseer;
    uint256 public codexCount;

    struct TrustRule {
        uint256 id;
        string principle;   // Override, Transparency, Resilience
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => TrustRule> public rules;
    event TrustRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareTrustRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = TrustRule(codexCount, principle, description, block.timestamp);
        emit TrustRuleDeclared(codexCount, principle, description);
    }
}
