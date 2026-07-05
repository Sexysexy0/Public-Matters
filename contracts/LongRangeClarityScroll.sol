pragma solidity ^0.8.20;

contract LongRangeClarityScroll {
    address public overseer;
    uint256 public scrollCount;

    struct ClarityRule {
        uint256 id;
        string principle;   // Long Range Clarity, Transparent Direction
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ClarityRule) public rules;
    event ClarityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareClarityRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = ClarityRule(scrollCount, principle, description, block.timestamp);
        emit ClarityRuleDeclared(scrollCount, principle, description);
    }
}
