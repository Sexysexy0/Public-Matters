pragma solidity ^0.8.20;

contract ChallengeTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct ChallengeRule {
        uint256 id;
        string principle;   // Testing, Debate, Constructive Opposition
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ChallengeRule) public treaties;
    event ChallengeRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareChallengeRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = ChallengeRule(treatyCount, principle, description, block.timestamp);
        emit ChallengeRuleDeclared(treatyCount, principle, description);
    }
}
