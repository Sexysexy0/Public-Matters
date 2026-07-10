pragma solidity ^0.8.20;

contract DialogCodex {
    address public overseer;
    uint256 public codexCount;

    struct DialogRule {
        uint256 id;
        string principle;   // Conversation, Respect, Exchange of Ideas
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => DialogRule) public rules;
    event DialogRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareDialogRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = DialogRule(codexCount, principle, description, block.timestamp);
        emit DialogRuleDeclared(codexCount, principle, description);
    }
}
