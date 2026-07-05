pragma solidity ^0.8.20;

contract DebateCodex {
    address public overseer;
    uint256 public codexCount;

    struct DebateRule {
        uint256 id;
        string principle;   // Dialogue, Argumentation, Truth-Testing
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => DebateRule) public rules;
    event DebateRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareDebateRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = DebateRule(codexCount, principle, description, block.timestamp);
        emit DebateRuleDeclared(codexCount, principle, description);
    }
}
