pragma solidity ^0.8.20;

contract FluencyCodex {
    address public overseer;
    uint256 public codexCount;

    struct FluencyRule {
        uint256 id;
        string principle;   // Fluency, Belief to Literacy
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => FluencyRule) public rules;
    event FluencyRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareFluencyRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = FluencyRule(codexCount, principle, description, block.timestamp);
        emit FluencyRuleDeclared(codexCount, principle, description);
    }
}
