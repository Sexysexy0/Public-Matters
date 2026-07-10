pragma solidity ^0.8.20;

contract KindnessLedger {
    address public overseer;
    uint256 public entryCount;

    struct KindnessRule {
        uint256 id;
        string principle;   // Kindness, Humane Treatment
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => KindnessRule) public entries;
    event KindnessRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareKindnessRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = KindnessRule(entryCount, principle, description, block.timestamp);
        emit KindnessRuleDeclared(entryCount, principle, description);
    }
}
