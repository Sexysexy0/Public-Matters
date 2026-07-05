pragma solidity ^0.8.20;

contract InnovationCodex {
    address public overseer;
    uint256 public codexCount;

    struct InnovationRule {
        uint256 id;
        string principle;   // Innovation, Breakthroughs, Future Vision
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => InnovationRule) public rules;
    event InnovationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareInnovationRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = InnovationRule(codexCount, principle, description, block.timestamp);
        emit InnovationRuleDeclared(codexCount, principle, description);
    }
}
