pragma solidity ^0.8.20;

contract EcoShadeTreaty {
    address public overseer;
    uint256 public treeCount;

    struct ShadeRule {
        uint256 id;
        string principle;   // Tree Planting, Shade, Cooling
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ShadeRule) public rules;
    event ShadeRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareShadeRule(string calldata principle, string calldata description) external onlyOverseer {
        treeCount++;
        rules[treeCount] = ShadeRule(treeCount, principle, description, block.timestamp);
        emit ShadeRuleDeclared(treeCount, principle, description);
    }
}
