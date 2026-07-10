pragma solidity ^0.8.20;

contract SacrificeLedger {
    address public overseer;
    uint256 public entryCount;

    struct SacrificeRule {
        uint256 id;
        string principle;   // Sacrifice, Shedding Dead Weight
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SacrificeRule) public entries;
    event SacrificeRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSacrificeRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = SacrificeRule(entryCount, principle, description, block.timestamp);
        emit SacrificeRuleDeclared(entryCount, principle, description);
    }
}
