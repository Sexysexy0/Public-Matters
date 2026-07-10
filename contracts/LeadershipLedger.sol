pragma solidity ^0.8.20;

contract LeadershipLedger {
    address public overseer;
    uint256 public entryCount;

    struct LeadershipRule {
        uint256 id;
        string principle;   // Leadership, Guidance, Spirit of Being
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => LeadershipRule) public entries;
    event LeadershipRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareLeadershipRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = LeadershipRule(entryCount, principle, description, block.timestamp);
        emit LeadershipRuleDeclared(entryCount, principle, description);
    }
}
