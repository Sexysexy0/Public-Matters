pragma solidity ^0.8.20;

contract WellbeingPolicyCodex {
    address public overseer;
    uint256 public codexCount;

    struct WellbeingRule {
        uint256 id;
        string principle;   // Wellbeing Policy, Public Welfare
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => WellbeingRule) public rules;
    event WellbeingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareWellbeingRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = WellbeingRule(codexCount, principle, description, block.timestamp);
        emit WellbeingRuleDeclared(codexCount, principle, description);
    }
}
