pragma solidity ^0.8.20;

contract MomentumCodex {
    address public overseer;
    uint256 public codexCount;

    struct MomentumRule {
        uint256 id;
        string principle;   // Momentum, Continuity, Creativity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => MomentumRule) public rules;
    event MomentumRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareMomentumRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = MomentumRule(codexCount, principle, description, block.timestamp);
        emit MomentumRuleDeclared(codexCount, principle, description);
    }
}
