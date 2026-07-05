pragma solidity ^0.8.20;

contract GreenCorridorCodex {
    address public overseer;
    uint256 public corridorCount;

    struct CorridorRule {
        uint256 id;
        string principle;   // Green Corridor, Cooling, Resilience
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CorridorRule) public rules;
    event CorridorRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCorridorRule(string calldata principle, string calldata description) external onlyOverseer {
        corridorCount++;
        rules[corridorCount] = CorridorRule(corridorCount, principle, description, block.timestamp);
        emit CorridorRuleDeclared(corridorCount, principle, description);
    }
}
