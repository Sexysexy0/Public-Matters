pragma solidity ^0.8.20;

contract SustainedCreativityScroll {
    address public overseer;
    uint256 public scrollCount;

    struct CreativityRule {
        uint256 id;
        string principle;   // Sustained Creativity, Innovation
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CreativityRule) public rules;
    event CreativityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCreativityRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = CreativityRule(scrollCount, principle, description, block.timestamp);
        emit CreativityRuleDeclared(scrollCount, principle, description);
    }
}
