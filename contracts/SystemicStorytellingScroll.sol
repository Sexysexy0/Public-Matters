pragma solidity ^0.8.20;

contract SystemicStorytellingScroll {
    address public overseer;
    uint256 public scrollCount;

    struct StorytellingRule {
        uint256 id;
        string principle;   // Systemic Storytelling, Governance Narrative
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => StorytellingRule) public rules;
    event StorytellingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareStorytellingRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = StorytellingRule(scrollCount, principle, description, block.timestamp);
        emit StorytellingRuleDeclared(scrollCount, principle, description);
    }
}
