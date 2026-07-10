pragma solidity ^0.8.20;

contract AbundanceCodex {
    address public overseer;
    uint256 public codexCount;

    struct AbundanceRule {
        uint256 id;
        string principle;   // Abundance, Generosity, Sustainability
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => AbundanceRule) public rules;
    event AbundanceRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareAbundanceRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = AbundanceRule(codexCount, principle, description, block.timestamp);
        emit AbundanceRuleDeclared(codexCount, principle, description);
    }
}
