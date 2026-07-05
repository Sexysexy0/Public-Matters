pragma solidity ^0.8.20;

/// @title AIAccountabilityCodex
/// @notice Encodes covenant for accountability in AI systems.
/// @dev Anchors responsibility, transparency, and safeguard rules.

contract AIAccountabilityCodex {
    address public overseer;
    uint256 public codexCount;

    struct AccountabilityRule {
        uint256 id;
        string principle;   // Responsibility, Transparency, Safeguard
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => AccountabilityRule> public rules;
    event AccountabilityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareAccountabilityRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = AccountabilityRule(codexCount, principle, description, block.timestamp);
        emit AccountabilityRuleDeclared(codexCount, principle, description);
    }
}
