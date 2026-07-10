pragma solidity ^0.8.20;

contract CommitLogsLedger {
    address public overseer;
    uint256 public entryCount;

    struct CommitRule {
        uint256 id;
        string principle;   // Commit Logs, Code Provenance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CommitRule) public entries;
    event CommitRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCommitRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = CommitRule(entryCount, principle, description, block.timestamp);
        emit CommitRuleDeclared(entryCount, principle, description);
    }
}
