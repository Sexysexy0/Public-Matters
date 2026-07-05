pragma solidity ^0.8.20;

contract ListeningCodex {
    address public overseer;
    uint256 public codexCount;

    struct ListeningRule {
        uint256 id;
        string principle;   // Attentiveness, Empathy, Active Reception
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ListeningRule) public rules;
    event ListeningRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareListeningRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = ListeningRule(codexCount, principle, description, block.timestamp);
        emit ListeningRuleDeclared(codexCount, principle, description);
    }
}
