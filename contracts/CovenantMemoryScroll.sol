pragma solidity ^0.8.20;

contract CovenantMemoryScroll {
    address public overseer;
    uint256 public scrollCount;

    struct MemoryRule {
        uint256 id;
        string principle;   // Covenant Memory, Generational Wisdom
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => MemoryRule) public rules;
    event MemoryRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareMemoryRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = MemoryRule(scrollCount, principle, description, block.timestamp);
        emit MemoryRuleDeclared(scrollCount, principle, description);
    }
}
