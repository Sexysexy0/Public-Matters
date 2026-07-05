pragma solidity ^0.8.20;

contract FortitudeCodex {
    address public overseer;
    uint256 public codexCount;

    struct FortitudeRule {
        uint256 id;
        string principle;   // Fortitude, Perseverance, Resolve
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => FortitudeRule) public rules;
    event FortitudeRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareFortitudeRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = FortitudeRule(codexCount, principle, description, block.timestamp);
        emit FortitudeRuleDeclared(codexCount, principle, description);
    }
}
