pragma solidity ^0.8.20;

contract WholeLifeScroll {
    address public overseer;
    uint256 public scrollCount;

    struct LifeRule {
        uint256 id;
        string principle;   // Whole Life, Sammā Alignment
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => LifeRule) public rules;
    event LifeRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareLifeRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = LifeRule(scrollCount, principle, description, block.timestamp);
        emit LifeRuleDeclared(scrollCount, principle, description);
    }
}
