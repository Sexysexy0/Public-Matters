pragma solidity ^0.8.20;

/// @title GlobalInnovationLedger
/// @notice Encodes global innovation collaboration rules.
/// @dev Anchors partnerships, shared research, and cross-border projects.

contract GlobalInnovationLedger {
    address public overseer;
    uint256 public entryCount;

    struct InnovationRule {
        uint256 id;
        string principle;   // Partnership, Research, Collaboration
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => InnovationRule> public entries;
    event InnovationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareInnovationRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = InnovationRule(entryCount, principle, description, block.timestamp);
        emit InnovationRuleDeclared(entryCount, principle, description);
    }
}
