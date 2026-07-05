pragma solidity ^0.8.20;

contract EmergentContinuityCodex {
    address public overseer;
    uint256 public codexCount;

    struct ContinuityRule {
        uint256 id;
        string principle;   // Emergent Continuity, Adaptive Immersion, Persistence
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ContinuityRule) public rules;
    event ContinuityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareContinuityRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = ContinuityRule(codexCount, principle, description, block.timestamp);
        emit ContinuityRuleDeclared(codexCount, principle, description);
    }
}
