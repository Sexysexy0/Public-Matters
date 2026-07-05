pragma solidity ^0.8.20;

contract RiskScroll {
    address public overseer;
    uint256 public scrollCount;

    struct RiskRule {
        uint256 id;
        string principle;   // Calculated Danger, Transformative Leaps, Bold Ventures
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => RiskRule) public rules;
    event RiskRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareRiskRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = RiskRule(scrollCount, principle, description, block.timestamp);
        emit RiskRuleDeclared(scrollCount, principle, description);
    }
}
