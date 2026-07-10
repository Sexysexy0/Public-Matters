pragma solidity ^0.8.20;

contract AutonomousUnitsLedger {
    address public overseer;
    uint256 public entryCount;

    struct UnitRule {
        uint256 id;
        string principle;   // Autonomous Units, Independence with Cooperation
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => UnitRule) public entries;
    event UnitRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareUnitRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = UnitRule(entryCount, principle, description, block.timestamp);
        emit UnitRuleDeclared(entryCount, principle, description);
    }
}
