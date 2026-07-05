pragma solidity ^0.8.20;

contract GentlenessScroll {
    address public overseer;
    uint256 public scrollCount;

    struct GentlenessRule {
        uint256 id;
        string principle;   // Gentleness, Humane Governance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => GentlenessRule) public rules;
    event GentlenessRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareGentlenessRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = GentlenessRule(scrollCount, principle, description, block.timestamp);
        emit GentlenessRuleDeclared(scrollCount, principle, description);
    }
}
