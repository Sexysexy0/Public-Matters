pragma solidity ^0.8.20;

contract LivedMeaningScroll {
    address public overseer;
    uint256 public scrollCount;

    struct MeaningRule {
        uint256 id;
        string principle;   // Lived Meaning, Resonance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => MeaningRule) public rules;
    event MeaningRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareMeaningRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = MeaningRule(scrollCount, principle, description, block.timestamp);
        emit MeaningRuleDeclared(scrollCount, principle, description);
    }
}
