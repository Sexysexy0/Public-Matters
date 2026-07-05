pragma solidity ^0.8.20;

contract BelievabilityTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct BelievabilityRule {
        uint256 id;
        string principle;   // Believability, Authentic NPC Behavior
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => BelievabilityRule) public treaties;
    event BelievabilityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareBelievabilityRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = BelievabilityRule(treatyCount, principle, description, block.timestamp);
        emit BelievabilityRuleDeclared(treatyCount, principle, description);
    }
}
