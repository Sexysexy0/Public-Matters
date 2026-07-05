pragma solidity ^0.8.20;

contract VitalityLedger {
    address public overseer;
    uint256 public entryCount;

    struct VitalityRule {
        uint256 id;
        string principle;   // Vitality, Energy, Thriving
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => VitalityRule) public entries;
    event VitalityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareVitalityRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = VitalityRule(entryCount, principle, description, block.timestamp);
        emit VitalityRuleDeclared(entryCount, principle, description);
    }
}
