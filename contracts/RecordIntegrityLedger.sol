pragma solidity ^0.8.20;

contract RecordIntegrityLedger {
    address public overseer;
    uint256 public entryCount;

    struct IntegrityRule {
        uint256 id;
        string principle;   // Record Integrity, Authenticity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => IntegrityRule) public entries;
    event IntegrityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareIntegrityRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = IntegrityRule(entryCount, principle, description, block.timestamp);
        emit IntegrityRuleDeclared(entryCount, principle, description);
    }
}
