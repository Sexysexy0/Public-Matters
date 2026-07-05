pragma solidity ^0.8.20;

contract HealingTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct HealingRule {
        uint256 id;
        string principle;   // Healing, Wholeness, Restoration
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => HealingRule) public treaties;
    event HealingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareHealingRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = HealingRule(treatyCount, principle, description, block.timestamp);
        emit HealingRuleDeclared(treatyCount, principle, description);
    }
}
