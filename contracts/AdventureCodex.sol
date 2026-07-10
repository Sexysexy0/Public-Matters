pragma solidity ^0.8.20;

contract AdventureCodex {
    address public overseer;
    uint256 public codexCount;

    struct AdventureRule {
        uint256 id;
        string principle;   // Exploration, Courage, Risk-Taking
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => AdventureRule) public rules;
    event AdventureRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareAdventureRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = AdventureRule(codexCount, principle, description, block.timestamp);
        emit AdventureRuleDeclared(codexCount, principle, description);
    }
}
