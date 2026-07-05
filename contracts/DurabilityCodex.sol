pragma solidity ^0.8.20;

contract DurabilityCodex {
    address public overseer;
    uint256 public codexCount;

    struct DurabilityRule {
        uint256 id;
        string principle;   // Durability, Permanence, Endurance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => DurabilityRule) public rules;
    event DurabilityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareDurabilityRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = DurabilityRule(codexCount, principle, description, block.timestamp);
        emit DurabilityRuleDeclared(codexCount, principle, description);
    }
}
