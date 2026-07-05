pragma solidity ^0.8.20;

contract QuestioningCodex {
    address public overseer;
    uint256 public codexCount;

    struct QuestioningRule {
        uint256 id;
        string principle;   // Curiosity, Challenge, Pursuit of Answers
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => QuestioningRule) public rules;
    event QuestioningRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareQuestioningRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = QuestioningRule(codexCount, principle, description, block.timestamp);
        emit QuestioningRuleDeclared(codexCount, principle, description);
    }
}
