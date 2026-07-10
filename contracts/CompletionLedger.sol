pragma solidity ^0.8.20;

contract CompletionLedger {
    address public overseer;
    uint256 public entryCount;

    struct CompletionRule {
        uint256 id;
        string principle;   // Completion, Fulfillment
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CompletionRule) public entries;
    event CompletionRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCompletionRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = CompletionRule(entryCount, principle, description, block.timestamp);
        emit CompletionRuleDeclared(entryCount, principle, description);
    }
}
