pragma solidity ^0.8.20;

contract CourageLedger {
    address public overseer;
    uint256 public entryCount;

    struct CourageRule {
        uint256 id;
        string principle;   // Bravery, Resilience, Fearless Pursuit
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CourageRule) public entries;
    event CourageRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCourageRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = CourageRule(entryCount, principle, description, block.timestamp);
        emit CourageRuleDeclared(entryCount, principle, description);
    }
}
