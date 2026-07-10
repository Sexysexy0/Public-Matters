pragma solidity ^0.8.20;

contract FeedbackCodex {
    address public overseer;
    uint256 public codexCount;

    struct FeedbackRule {
        uint256 id;
        string principle;   // Feedback, Comments, Audit Trail
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => FeedbackRule) public rules;
    event FeedbackRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareFeedbackRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = FeedbackRule(codexCount, principle, description, block.timestamp);
        emit FeedbackRuleDeclared(codexCount, principle, description);
    }
}
