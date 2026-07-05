pragma solidity ^0.8.20;

contract EffortScroll {
    address public overseer;
    uint256 public scrollCount;

    struct EffortRule {
        uint256 id;
        string principle;   // Discipline, Persistence, Purposeful Labor
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => EffortRule) public rules;
    event EffortRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareEffortRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = EffortRule(scrollCount, principle, description, block.timestamp);
        emit EffortRuleDeclared(scrollCount, principle, description);
    }
}
