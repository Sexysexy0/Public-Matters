pragma solidity ^0.8.20;

contract HealingCodex {
    address public overseer;
    uint256 public codexCount;

    struct HealingRule {
        uint256 id;
        string principle;   // Wholeness, Repair, Restoration
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => HealingRule) public rules;
    event HealingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareHealingRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = HealingRule(codexCount, principle, description, block.timestamp);
        emit HealingRuleDeclared(codexCount, principle, description);
    }
}
