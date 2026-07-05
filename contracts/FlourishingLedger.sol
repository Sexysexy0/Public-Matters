pragma solidity ^0.8.20;

contract FlourishingLedger {
    address public overseer;
    uint256 public entryCount;

    struct FlourishingRule {
        uint256 id;
        string principle;   // Flourishing, Well-being, Collective Vitality
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => FlourishingRule) public entries;
    event FlourishingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareFlourishingRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = FlourishingRule(entryCount, principle, description, block.timestamp);
        emit FlourishingRuleDeclared(entryCount, principle, description);
    }
}
