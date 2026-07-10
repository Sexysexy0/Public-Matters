pragma solidity ^0.8.20;

contract VisionCodex {
    address public overseer;
    uint256 public codexCount;

    struct VisionRule {
        uint256 id;
        string principle;   // Vision, Foresight, Clarity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => VisionRule) public rules;
    event VisionRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareVisionRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = VisionRule(codexCount, principle, description, block.timestamp);
        emit VisionRuleDeclared(codexCount, principle, description);
    }
}
