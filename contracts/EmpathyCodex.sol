pragma solidity ^0.8.20;

contract EmpathyCodex {
    address public overseer;
    uint256 public codexCount;

    struct EmpathyRule {
        uint256 id;
        string principle;   // Empathy, Connection, Relational Harmony
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => EmpathyRule) public rules;
    event EmpathyRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareEmpathyRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = EmpathyRule(codexCount, principle, description, block.timestamp);
        emit EmpathyRuleDeclared(codexCount, principle, description);
    }
}
