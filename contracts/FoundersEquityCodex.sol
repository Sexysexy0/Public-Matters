pragma solidity ^0.8.20;

/// @title FoundersEquityCodex
/// @notice Covenant for equity safeguards inspired by founders' wisdom.
/// @dev Anchors dignity, fairness, and governance continuity.

contract FoundersEquityCodex {
    address public overseer;
    uint256 public codexCount;

    struct EquityRule {
        uint256 id;
        string principle;   // Founders' Wisdom, Equity, Governance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => EquityRule) public rules;
    event EquityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareEquityRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = EquityRule(codexCount, principle, description, block.timestamp);
        emit EquityRuleDeclared(codexCount, principle, description);
    }
}
