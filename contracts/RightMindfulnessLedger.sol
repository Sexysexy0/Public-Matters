pragma solidity ^0.8.20;

contract RightMindfulnessLedger {
    address public overseer;
    uint256 public entryCount;

    struct MindfulnessRule {
        uint256 id;
        string principle;   // Right Mindfulness, Awareness
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => MindfulnessRule) public entries;
    event MindfulnessRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareMindfulnessRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = MindfulnessRule(entryCount, principle, description, block.timestamp);
        emit MindfulnessRuleDeclared(entryCount, principle, description);
    }
}
