pragma solidity ^0.8.20;

contract GovernancePersistenceLedger {
    address public overseer;
    uint256 public entryCount;

    struct PersistenceRule {
        uint256 id;
        string principle;   // Governance Persistence, Continuity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => PersistenceRule) public entries;
    event PersistenceRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declarePersistenceRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = PersistenceRule(entryCount, principle, description, block.timestamp);
        emit PersistenceRuleDeclared(entryCount, principle, description);
    }
}
