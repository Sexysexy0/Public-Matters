pragma solidity ^0.8.20;

contract VitalityCodex {
    address public overseer;
    uint256 public codexCount;

    struct VitalityRule {
        uint256 id;
        string principle;   // Vitality, Thriving, Flourishing
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => VitalityRule) public rules;
    event VitalityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareVitalityRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = VitalityRule(codexCount, principle, description, block.timestamp);
        emit VitalityRuleDeclared(codexCount, principle, description);
    }
}
