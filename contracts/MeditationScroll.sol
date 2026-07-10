pragma solidity ^0.8.20;

contract MeditationScroll {
    address public overseer;
    uint256 public scrollCount;

    struct MeditationRule {
        uint256 id;
        string principle;   // Meditation, Effort, Mindfulness, Concentration
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => MeditationRule) public rules;
    event MeditationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareMeditationRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = MeditationRule(scrollCount, principle, description, block.timestamp);
        emit MeditationRuleDeclared(scrollCount, principle, description);
    }
}
