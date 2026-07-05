pragma solidity ^0.8.20;

contract ConversationCodex {
    address public overseer;
    uint256 public codexCount;

    struct ConversationRule {
        uint256 id;
        string principle;   // Listening, Understanding, Dialogue
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ConversationRule) public rules;
    event ConversationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareConversationRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = ConversationRule(codexCount, principle, description, block.timestamp);
        emit ConversationRuleDeclared(codexCount, principle, description);
    }
}
