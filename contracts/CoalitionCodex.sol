pragma solidity ^0.8.20;

contract CoalitionCodex {
    address public overseer;
    uint256 public codexCount;

    struct CoalitionRule {
        uint256 id;
        string principle;   // Coalition, Unity, Alignment
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CoalitionRule) public rules;
    event CoalitionRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCoalitionRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = CoalitionRule(codexCount, principle, description, block.timestamp);
        emit CoalitionRuleDeclared(codexCount, principle, description);
    }
}
