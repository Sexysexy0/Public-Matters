pragma solidity ^0.8.20;

contract GreatnessCodex {
    address public overseer;
    uint256 public codexCount;

    struct GreatnessRule {
        uint256 id;
        string principle;   // Greatness, Ambition, Progress
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => GreatnessRule) public rules;
    event GreatnessRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareGreatnessRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = GreatnessRule(codexCount, principle, description, block.timestamp);
        emit GreatnessRuleDeclared(codexCount, principle, description);
    }
}
