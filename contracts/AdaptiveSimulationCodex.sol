pragma solidity ^0.8.20;

contract AdaptiveSimulationCodex {
    address public overseer;
    uint256 public codexCount;

    struct AdaptiveRule {
        uint256 id;
        string principle;   // Adaptive Simulation, Dynamic Routines, Emergent Behavior
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => AdaptiveRule) public rules;
    event AdaptiveRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareAdaptiveRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = AdaptiveRule(codexCount, principle, description, block.timestamp);
        emit AdaptiveRuleDeclared(codexCount, principle, description);
    }
}
