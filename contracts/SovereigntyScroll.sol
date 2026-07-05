pragma solidity ^0.8.20;

contract SovereigntyScroll {
    address public overseer;
    uint256 public scrollCount;

    struct SovereigntyRule {
        uint256 id;
        string principle;   // Sovereignty of the People
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SovereigntyRule) public rules;
    event SovereigntyRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSovereigntyRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = SovereigntyRule(scrollCount, principle, description, block.timestamp);
        emit SovereigntyRuleDeclared(scrollCount, principle, description);
    }
}
