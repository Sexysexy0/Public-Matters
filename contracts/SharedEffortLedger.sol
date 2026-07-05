pragma solidity ^0.8.20;

contract SharedEffortLedger {
    address public overseer;
    uint256 public entryCount;

    struct EffortRule {
        uint256 id;
        string principle;   // Shared Effort, Collective Responsibility
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => EffortRule) public entries;
    event EffortRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareEffortRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = EffortRule(entryCount, principle, description, block.timestamp);
        emit EffortRuleDeclared(entryCount, principle, description);
    }
}
