pragma solidity ^0.8.20;

contract CommunityGreenScroll {
    address public overseer;
    uint256 public scrollCount;

    struct GreenRule {
        uint256 id;
        string principle;   // Community Garden, Cooling, Resilience
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => GreenRule) public rules;
    event GreenRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareGreenRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = GreenRule(scrollCount, principle, description, block.timestamp);
        emit GreenRuleDeclared(scrollCount, principle, description);
    }
}
