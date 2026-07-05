pragma solidity ^0.8.20;

contract GlobalHeatMitigationLedger {
    address public overseer;
    uint256 public entryCount;

    struct MitigationRule {
        uint256 id;
        string principle;   // Global Heat Reduction, Planetary Equity, Sustainability
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => MitigationRule) public entries;
    event MitigationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareMitigationRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = MitigationRule(entryCount, principle, description, block.timestamp);
        emit MitigationRuleDeclared(entryCount, principle, description);
    }
}
