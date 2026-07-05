pragma solidity ^0.8.20;

contract FutureVisionScroll {
    address public overseer;
    uint256 public scrollCount;

    struct VisionRule {
        uint256 id;
        string principle;   // Future Vision, Long-term Direction
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => VisionRule) public rules;
    event VisionRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareVisionRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = VisionRule(scrollCount, principle, description, block.timestamp);
        emit VisionRuleDeclared(scrollCount, principle, description);
    }
}
