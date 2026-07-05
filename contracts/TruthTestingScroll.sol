pragma solidity ^0.8.20;

contract TruthTestingScroll {
    address public overseer;
    uint256 public scrollCount;

    struct TruthTestingRule {
        uint256 id;
        string principle;   // Verification, Evidence, Reality
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => TruthTestingRule) public rules;
    event TruthTestingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareTruthTestingRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = TruthTestingRule(scrollCount, principle, description, block.timestamp);
        emit TruthTestingRuleDeclared(scrollCount, principle, description);
    }
}
