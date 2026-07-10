pragma solidity ^0.8.20;

contract GoodwillCodex {
    address public overseer;
    uint256 public codexCount;

    struct GoodwillRule {
        uint256 id;
        string principle;   // Goodwill, Benevolence, Trust
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => GoodwillRule) public rules;
    event GoodwillRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareGoodwillRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = GoodwillRule(codexCount, principle, description, block.timestamp);
        emit GoodwillRuleDeclared(codexCount, principle, description);
    }
}
