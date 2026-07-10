pragma solidity ^0.8.20;

contract EnvironmentalCyclesLedger {
    address public overseer;
    uint256 public entryCount;

    struct CycleRule {
        uint256 id;
        string principle;   // Environmental Cycles, Rhythms
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CycleRule) public entries;
    event CycleRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCycleRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = CycleRule(entryCount, principle, description, block.timestamp);
        emit CycleRuleDeclared(entryCount, principle, description);
    }
}
