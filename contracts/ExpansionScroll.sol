pragma solidity ^0.8.20;

contract ExpansionScroll {
    address public overseer;
    uint256 public scrollCount;

    struct ExpansionRule {
        uint256 id;
        string principle;   // Growth, Outreach, Frontier Exploration
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ExpansionRule) public rules;
    event ExpansionRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareExpansionRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = ExpansionRule(scrollCount, principle, description, block.timestamp);
        emit ExpansionRuleDeclared(scrollCount, principle, description);
    }
}
