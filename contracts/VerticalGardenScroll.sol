pragma solidity ^0.8.20;

contract VerticalGardenScroll {
    address public overseer;
    uint256 public gardenCount;

    struct GardenRule {
        uint256 id;
        string principle;   // Vertical Garden, Insulation, Cooling
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => GardenRule) public rules;
    event GardenRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareGardenRule(string calldata principle, string calldata description) external onlyOverseer {
        gardenCount++;
        rules[gardenCount] = GardenRule(gardenCount, principle, description, block.timestamp);
        emit GardenRuleDeclared(gardenCount, principle, description);
    }
}
