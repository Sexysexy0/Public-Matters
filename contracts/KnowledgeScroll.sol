pragma solidity ^0.8.20;

contract KnowledgeScroll {
    address public overseer;
    uint256 public scrollCount;

    struct KnowledgeRule {
        uint256 id;
        string principle;   // Learning, Wisdom, Enlightenment
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => KnowledgeRule) public rules;
    event KnowledgeRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareKnowledgeRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = KnowledgeRule(scrollCount, principle, description, block.timestamp);
        emit KnowledgeRuleDeclared(scrollCount, principle, description);
    }
}
