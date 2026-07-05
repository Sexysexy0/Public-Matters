pragma solidity ^0.8.20;

contract TruthScroll {
    address public overseer;
    uint256 public scrollCount;

    struct TruthRule {
        uint256 id;
        string principle;   // Truth, Fairness, Honest Governance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => TruthRule) public rules;
    event TruthRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareTruthRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = TruthRule(scrollCount, principle, description, block.timestamp);
        emit TruthRuleDeclared(scrollCount, principle, description);
    }
}
