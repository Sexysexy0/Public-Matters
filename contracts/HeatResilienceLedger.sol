pragma solidity ^0.8.20;

contract HeatResilienceLedger {
    address public overseer;
    uint256 public entryCount;

    struct HeatRule {
        uint256 id;
        string principle;   // Heat Resilience, Worker Fairness, Community Equity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => HeatRule) public entries;
    event HeatRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareHeatRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = HeatRule(entryCount, principle, description, block.timestamp);
        emit HeatRuleDeclared(entryCount, principle, description);
    }
}
