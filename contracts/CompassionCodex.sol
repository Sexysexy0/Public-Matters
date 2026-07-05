pragma solidity ^0.8.20;

contract CompassionCodex {
    address public overseer;
    uint256 public codexCount;

    struct CompassionRule {
        uint256 id;
        string principle;   // Compassion, Empathy, Care
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CompassionRule) public rules;
    event CompassionRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCompassionRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = CompassionRule(codexCount, principle, description, block.timestamp);
        emit CompassionRuleDeclared(codexCount, principle, description);
    }
}
