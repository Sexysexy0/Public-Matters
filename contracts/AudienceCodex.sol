pragma solidity ^0.8.20;

contract AudienceCodex {
    address public overseer;
    uint256 public codexCount;

    struct AudienceRule {
        uint256 id;
        string principle;   // Feedback, Respect, Resonance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => AudienceRule) public rules;
    event AudienceRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareAudienceRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = AudienceRule(codexCount, principle, description, block.timestamp);
        emit AudienceRuleDeclared(codexCount, principle, description);
    }
}
