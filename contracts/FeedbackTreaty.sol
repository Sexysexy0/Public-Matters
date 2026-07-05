pragma solidity ^0.8.20;

contract FeedbackTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct FeedbackRule {
        uint256 id;
        string principle;   // Grassroots Feedback, Audience Listening
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => FeedbackRule) public treaties;
    event FeedbackRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareFeedbackRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = FeedbackRule(treatyCount, principle, description, block.timestamp);
        emit FeedbackRuleDeclared(treatyCount, principle, description);
    }
}
