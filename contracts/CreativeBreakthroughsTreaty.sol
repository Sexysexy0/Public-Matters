pragma solidity ^0.8.20;

contract CreativeBreakthroughsTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct BreakthroughRule {
        uint256 id;
        string principle;   // Creative Breakthroughs, Radical Ideas
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => BreakthroughRule) public treaties;
    event BreakthroughRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareBreakthroughRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = BreakthroughRule(treatyCount, principle, description, block.timestamp);
        emit BreakthroughRuleDeclared(treatyCount, principle, description);
    }
}
