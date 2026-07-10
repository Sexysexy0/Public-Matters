pragma solidity ^0.8.20;

contract DialogueScroll {
    address public overseer;
    uint256 public scrollCount;

    struct DialogueRule {
        uint256 id;
        string principle;   // Respectful Exchange, Collaboration, Balanced Discourse
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => DialogueRule) public rules;
    event DialogueRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareDialogueRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = DialogueRule(scrollCount, principle, description, block.timestamp);
        emit DialogueRuleDeclared(scrollCount, principle, description);
    }
}
