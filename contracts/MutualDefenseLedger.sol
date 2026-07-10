pragma solidity ^0.8.20;

contract MutualDefenseLedger {
    address public overseer;
    uint256 public entryCount;

    struct DefenseRule {
        uint256 id;
        string principle;   // Mutual Defense, Protection
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => DefenseRule) public entries;
    event DefenseRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareDefenseRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = DefenseRule(entryCount, principle, description, block.timestamp);
        emit DefenseRuleDeclared(entryCount, principle, description);
    }
}
