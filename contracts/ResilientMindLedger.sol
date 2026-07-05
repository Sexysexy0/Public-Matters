pragma solidity ^0.8.20;

/// @title ResilientMindLedger
/// @notice Covenant for resilient mind safeguards.
/// @dev Anchors discipline, emotional regulation, and dignity.

contract ResilientMindLedger {
    address public overseer;
    uint256 public entryCount;

    struct MindRule {
        uint256 id;
        string principle;   // Resilient Mind, Discipline, Dignity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => MindRule) public entries;
    event MindRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareMindRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = MindRule(entryCount, principle, description, block.timestamp);
        emit MindRuleDeclared(entryCount, principle, description);
    }
}
