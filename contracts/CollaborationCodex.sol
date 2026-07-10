pragma solidity ^0.8.20;

contract CollaborationCodex {
    address public overseer;
    uint256 public codexCount;

    struct CollaborationRule {
        uint256 id;
        string principle;   // Collaboration, Mutual Support, Partnership
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CollaborationRule) public rules;
    event CollaborationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCollaborationRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = CollaborationRule(codexCount, principle, description, block.timestamp);
        emit CollaborationRuleDeclared(codexCount, principle, description);
    }
}
