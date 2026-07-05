pragma solidity ^0.8.20;

contract DespairCodex {
    address public overseer;
    uint256 public codexCount;

    struct DespairRule {
        uint256 id;
        string principle;   // Despair, Existential Weight, Collapse Awareness
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => DespairRule) public rules;
    event DespairRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareDespairRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = DespairRule(codexCount, principle, description, block.timestamp);
        emit DespairRuleDeclared(codexCount, principle, description);
    }
}
