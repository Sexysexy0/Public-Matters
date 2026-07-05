pragma solidity ^0.8.20;

contract FlamingSwordScroll {
    address public overseer;
    uint256 public scrollCount;

    struct SwordRule {
        uint256 id;
        string principle;   // Barrier, Sacrifice Threshold, Path to Paradise
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SwordRule) public rules;
    event SwordRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSwordRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = SwordRule(scrollCount, principle, description, block.timestamp);
        emit SwordRuleDeclared(scrollCount, principle, description);
    }
}
