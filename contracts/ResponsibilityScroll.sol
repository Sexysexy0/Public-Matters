pragma solidity ^0.8.20;

contract ResponsibilityScroll {
    address public overseer;
    uint256 public scrollCount;

    struct ResponsibilityRule {
        uint256 id;
        string principle;   // Responsibility, Duty, Destiny Fulfillment
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ResponsibilityRule) public rules;
    event ResponsibilityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareResponsibilityRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = ResponsibilityRule(scrollCount, principle, description, block.timestamp);
        emit ResponsibilityRuleDeclared(scrollCount, principle, description);
    }
}
