pragma solidity ^0.8.20;

contract RightIntentionLedger {
    address public overseer;
    uint256 public entryCount;

    struct IntentionRule {
        uint256 id;
        string principle;   // Right Intention, Goodwill, Letting Go
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => IntentionRule) public entries;
    event IntentionRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareIntentionRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = IntentionRule(entryCount, principle, description, block.timestamp);
        emit IntentionRuleDeclared(entryCount, principle, description);
    }
}
