pragma solidity ^0.8.20;

contract RegenerationCodex {
    address public overseer;
    uint256 public codexCount;

    struct RegenerationRule {
        uint256 id;
        string principle;   // Regeneration, Renewal, Vitality
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => RegenerationRule) public rules;
    event RegenerationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareRegenerationRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = RegenerationRule(codexCount, principle, description, block.timestamp);
        emit RegenerationRuleDeclared(codexCount, principle, description);
    }
}
