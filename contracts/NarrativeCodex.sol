pragma solidity ^0.8.20;

contract NarrativeCodex {
    address public overseer;
    uint256 public codexCount;

    struct NarrativeRule {
        uint256 id;
        string principle;   // Narrative, Story Depth, Resonance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => NarrativeRule) public rules;
    event NarrativeRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareNarrativeRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = NarrativeRule(codexCount, principle, description, block.timestamp);
        emit NarrativeRuleDeclared(codexCount, principle, description);
    }
}
