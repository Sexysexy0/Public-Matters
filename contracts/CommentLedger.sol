pragma solidity ^0.8.20;

contract CommentLedger {
    address public overseer;
    uint256 public entryCount;

    struct CommentRule {
        uint256 id;
        string principle;   // Comment Feedback, Communal Validation
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CommentRule) public entries;
    event CommentRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCommentRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = CommentRule(entryCount, principle, description, block.timestamp);
        emit CommentRuleDeclared(entryCount, principle, description);
    }
}
