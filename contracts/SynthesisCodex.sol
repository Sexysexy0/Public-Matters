pragma solidity ^0.8.20;

contract SynthesisCodex {
    address public overseer;
    uint256 public codexCount;

    struct SynthesisRule {
        uint256 id;
        string principle;   // Synthesis, Holistic Unity, Coherence
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SynthesisRule) public rules;
    event SynthesisRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSynthesisRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = SynthesisRule(codexCount, principle, description, block.timestamp);
        emit SynthesisRuleDeclared(codexCount, principle, description);
    }
}
