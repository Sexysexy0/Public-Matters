pragma solidity ^0.8.20;

contract AttentionLedger {
    address public overseer;
    uint256 public entryCount;

    struct AttentionRule {
        uint256 id;
        string principle;   // Vigilance, Consistency, Focus
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => AttentionRule) public entries;
    event AttentionRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareAttentionRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = AttentionRule(entryCount, principle, description, block.timestamp);
        emit AttentionRuleDeclared(entryCount, principle, description);
    }
}
