pragma solidity ^0.8.20;

contract PassiveCoolingScroll {
    address public overseer;
    uint256 public scrollCount;

    struct CoolingRule {
        uint256 id;
        string principle;   // Passive Cooling, Non-electric, Fairness
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CoolingRule) public rules;
    event CoolingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCoolingRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = CoolingRule(scrollCount, principle, description, block.timestamp);
        emit CoolingRuleDeclared(scrollCount, principle, description);
    }
}
