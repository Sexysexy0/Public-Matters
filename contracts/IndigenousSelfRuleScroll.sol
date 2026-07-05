pragma solidity ^0.8.20;

contract IndigenousSelfRuleScroll {
    address public overseer;
    uint256 public scrollCount;

    struct SelfRule {
        uint256 id;
        string principle;   // Indigenous Self-Governance, Decoloniality
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SelfRule) public rules;
    event SelfRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSelfRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = SelfRule(scrollCount, principle, description, block.timestamp);
        emit SelfRuleDeclared(scrollCount, principle, description);
    }
}
