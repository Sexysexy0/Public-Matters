pragma solidity ^0.8.20;

contract GreenRoofCodex {
    address public overseer;
    uint256 public roofCount;

    struct RoofRule {
        uint256 id;
        string principle;   // Green Roof, Cooling, Sustainability
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => RoofRule) public rules;
    event RoofRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareRoofRule(string calldata principle, string calldata description) external onlyOverseer {
        roofCount++;
        rules[roofCount] = RoofRule(roofCount, principle, description, block.timestamp);
        emit RoofRuleDeclared(roofCount, principle, description);
    }
}
