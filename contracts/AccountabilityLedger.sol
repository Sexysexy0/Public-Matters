pragma solidity ^0.8.20;

contract AccountabilityLedger {
    address public overseer;
    uint256 public entryCount;

    struct AccountabilityRule {
        uint256 id;
        string principle;   // Transparency, Integrity, Responsibility
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => AccountabilityRule) public entries;
    event AccountabilityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareAccountabilityRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = AccountabilityRule(entryCount, principle, description, block.timestamp);
        emit AccountabilityRuleDeclared(entryCount, principle, description);
    }
}
