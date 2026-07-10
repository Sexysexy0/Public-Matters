pragma solidity ^0.8.20;

contract IntegrationLoopsLedger {
    address public overseer;
    uint256 public entryCount;

    struct LoopRule {
        uint256 id;
        string principle;   // Integration Loops, Feedback Cycles
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => LoopRule) public entries;
    event LoopRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareLoopRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = LoopRule(entryCount, principle, description, block.timestamp);
        emit LoopRuleDeclared(entryCount, principle, description);
    }
}
