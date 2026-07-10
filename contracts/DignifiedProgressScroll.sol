pragma solidity ^0.8.20;

contract DignifiedProgressScroll {
    address public overseer;
    uint256 public scrollCount;

    struct ProgressRule {
        uint256 id;
        string principle;   // Dignified Progress, Fair Advancement
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ProgressRule) public rules;
    event ProgressRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareProgressRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = ProgressRule(scrollCount, principle, description, block.timestamp);
        emit ProgressRuleDeclared(scrollCount, principle, description);
    }
}
