pragma solidity ^0.8.20;

/// @title AdaptiveGovernanceCodex
/// @notice Covenant for adaptive governance safeguards.
/// @dev Anchors dynamic fairness, resilience protocols, human-AI co-allocation.

contract AdaptiveGovernanceCodex {
    address public overseer;
    uint256 public codexCount;

    struct GovernanceRule {
        uint256 id;
        string principle;   // Adaptive Governance, Fairness, Resilience
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => GovernanceRule) public rules;
    event GovernanceRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareGovernanceRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = GovernanceRule(codexCount, principle, description, block.timestamp);
        emit GovernanceRuleDeclared(codexCount, principle, description);
    }
}
