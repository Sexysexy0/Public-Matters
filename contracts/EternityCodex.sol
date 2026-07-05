pragma solidity ^0.8.20;

contract EternityCodex {
    address public overseer;
    uint256 public codexCount;

    struct EternityRule {
        uint256 id;
        string principle;   // Eternity, Timeless Governance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => EternityRule) public rules;
    event EternityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareEternityRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = EternityRule(codexCount, principle, description, block.timestamp);
        emit EternityRuleDeclared(codexCount, principle, description);
    }
}
