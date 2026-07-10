pragma solidity ^0.8.20;

contract ChallengeCodex {
    address public overseer;
    uint256 public codexCount;

    struct ChallengeRule {
        uint256 id;
        string principle;   // Debate, Testing, Opposition
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ChallengeRule) public rules;
    event ChallengeRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareChallengeRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = ChallengeRule(codexCount, principle, description, block.timestamp);
        emit ChallengeRuleDeclared(codexCount, principle, description);
    }
}
