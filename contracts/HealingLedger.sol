pragma solidity ^0.8.20;

contract HealingLedger {
    address public overseer;
    uint256 public entryCount;

    struct HealingRule {
        uint256 id;
        string principle;   // Healing, Recovery, Care
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => HealingRule) public entries;
    event HealingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareHealingRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = HealingRule(entryCount, principle, description, block.timestamp);
        emit HealingRuleDeclared(entryCount, principle, description);
    }
}
