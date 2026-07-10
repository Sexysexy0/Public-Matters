pragma solidity ^0.8.20;

contract LeadershipCodex {
    address public overseer;
    uint256 public codexCount;

    struct LeadershipRule {
        uint256 id;
        string principle;   // Guidance, Courage, Transformation
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => LeadershipRule) public rules;
    event LeadershipRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareLeadershipRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = LeadershipRule(codexCount, principle, description, block.timestamp);
        emit LeadershipRuleDeclared(codexCount, principle, description);
    }
}
