pragma solidity ^0.8.20;

contract UnderstandingLedger {
    address public overseer;
    uint256 public entryCount;

    struct UnderstandingRule {
        uint256 id;
        string principle;   // Comprehension, Shared Meaning, Empathy
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => UnderstandingRule) public entries;
    event UnderstandingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareUnderstandingRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = UnderstandingRule(entryCount, principle, description, block.timestamp);
        emit UnderstandingRuleDeclared(entryCount, principle, description);
    }
}
