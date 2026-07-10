pragma solidity ^0.8.20;

contract TransparencyCodex {
    address public overseer;
    uint256 public codexCount;

    struct TransparencyRule {
        uint256 id;
        string principle;   // Transparency, Clarity, Accountability
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => TransparencyRule) public rules;
    event TransparencyRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareTransparencyRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = TransparencyRule(codexCount, principle, description, block.timestamp);
        emit TransparencyRuleDeclared(codexCount, principle, description);
    }
}
