pragma solidity ^0.8.20;

contract HolisticWellbeingScroll {
    address public overseer;
    uint256 public scrollCount;

    struct WellbeingRule {
        uint256 id;
        string principle;   // Holistic Wellbeing, Collective Health
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => WellbeingRule) public rules;
    event WellbeingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareWellbeingRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = WellbeingRule(scrollCount, principle, description, block.timestamp);
        emit WellbeingRuleDeclared(scrollCount, principle, description);
    }
}
