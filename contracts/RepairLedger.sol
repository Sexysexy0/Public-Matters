pragma solidity ^0.8.20;

contract RepairLedger {
    address public overseer;
    uint256 public entryCount;

    struct RepairRule {
        uint256 id;
        string principle;   // Repair, Restoration, Integrity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => RepairRule) public entries;
    event RepairRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareRepairRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = RepairRule(entryCount, principle, description, block.timestamp);
        emit RepairRuleDeclared(entryCount, principle, description);
    }
}
