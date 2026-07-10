pragma solidity ^0.8.20;

contract LivingSystemsCodex {
    address public overseer;
    uint256 public codexCount;

    struct LivingRule {
        uint256 id;
        string principle;   // Living Systems, Ecosystem, Continuity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => LivingRule) public rules;
    event LivingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareLivingRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = LivingRule(codexCount, principle, description, block.timestamp);
        emit LivingRuleDeclared(codexCount, principle, description);
    }
}
