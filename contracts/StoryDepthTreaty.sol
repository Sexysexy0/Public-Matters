pragma solidity ^0.8.20;

contract StoryDepthTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct StoryRule {
        uint256 id;
        string principle;   // Story Depth, Emotional Weight
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => StoryRule) public treaties;
    event StoryRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareStoryRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = StoryRule(treatyCount, principle, description, block.timestamp);
        emit StoryRuleDeclared(treatyCount, principle, description);
    }
}
