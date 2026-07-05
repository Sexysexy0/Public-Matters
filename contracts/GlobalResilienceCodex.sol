pragma solidity ^0.8.20;

/// @title GlobalResilienceCodex
/// @notice Covenant for planetary resilience safeguards.
/// @dev Anchors food, water, climate, and equity.

contract GlobalResilienceCodex {
    address public overseer;
    uint256 public codexCount;

    struct ResilienceRule {
        uint256 id;
        string principle;   // Global Resilience, Equity, Sustainability
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ResilienceRule) public rules;
    event ResilienceRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareResilienceRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = ResilienceRule(codexCount, principle, description, block.timestamp);
        emit ResilienceRuleDeclared(codexCount, principle, description);
    }
}
