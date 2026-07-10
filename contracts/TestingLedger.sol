pragma solidity ^0.8.20;

contract TestingLedger {
    address public overseer;
    uint256 public entryCount;

    struct TestingRule {
        uint256 id;
        string principle;   // Verification, Experimentation, Evaluation
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => TestingRule) public entries;
    event TestingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareTestingRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = TestingRule(entryCount, principle, description, block.timestamp);
        emit TestingRuleDeclared(entryCount, principle, description);
    }
}
