pragma solidity ^0.8.20;

contract KindnessCodex {
    address public overseer;
    uint256 public codexCount;

    struct KindnessRule {
        uint256 id;
        string principle;   // Kindness, Goodwill, Benevolence
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => KindnessRule) public rules;
    event KindnessRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareKindnessRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = KindnessRule(codexCount, principle, description, block.timestamp);
        emit KindnessRuleDeclared(codexCount, principle, description);
    }
}
