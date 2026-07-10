pragma solidity ^0.8.20;

contract SustainabilityLedger {
    address public overseer;
    uint256 public entryCount;

    struct SustainabilityRule {
        uint256 id;
        string principle;   // Sustainability, Ecological Fairness
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SustainabilityRule) public entries;
    event SustainabilityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSustainabilityRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = SustainabilityRule(entryCount, principle, description, block.timestamp);
        emit SustainabilityRuleDeclared(entryCount, principle, description);
    }
}
