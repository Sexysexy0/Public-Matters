pragma solidity ^0.8.20;

contract SammaCodex {
    address public overseer;
    uint256 public codexCount;

    struct SammaRule {
        uint256 id;
        string principle;   // Sammā, Alignment, Harmony
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SammaRule) public rules;
    event SammaRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSammaRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = SammaRule(codexCount, principle, description, block.timestamp);
        emit SammaRuleDeclared(codexCount, principle, description);
    }
}
