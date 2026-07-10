pragma solidity ^0.8.20;

contract GenerosityCodex {
    address public overseer;
    uint256 public codexCount;

    struct GenerosityRule {
        uint256 id;
        string principle;   // Generosity, Sharing, Uplift
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => GenerosityRule) public rules;
    event GenerosityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareGenerosityRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = GenerosityRule(codexCount, principle, description, block.timestamp);
        emit GenerosityRuleDeclared(codexCount, principle, description);
    }
}
