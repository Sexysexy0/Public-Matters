pragma solidity ^0.8.20;

contract AnswersLedger {
    address public overseer;
    uint256 public entryCount;

    struct AnswerRule {
        uint256 id;
        string principle;   // Resolution, Clarity, Truth
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => AnswerRule) public entries;
    event AnswerRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareAnswerRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = AnswerRule(entryCount, principle, description, block.timestamp);
        emit AnswerRuleDeclared(entryCount, principle, description);
    }
}
