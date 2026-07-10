pragma solidity ^0.8.20;

contract ConcentrationCodex {
    address public overseer;
    uint256 public codexCount;

    struct ConcentrationRule {
        uint256 id;
        string principle;   // Deep Work, Sustained Attention, Precision
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ConcentrationRule) public rules;
    event ConcentrationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareConcentrationRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = ConcentrationRule(codexCount, principle, description, block.timestamp);
        emit ConcentrationRuleDeclared(codexCount, principle, description);
    }
}
