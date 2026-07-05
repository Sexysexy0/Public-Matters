pragma solidity ^0.8.20;

contract ImmersionArcsLedger {
    address public overseer;
    uint256 public entryCount;

    struct ArcRule {
        uint256 id;
        string principle;   // Immersion Arcs, Player Storylines
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ArcRule) public entries;
    event ArcRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareArcRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = ArcRule(entryCount, principle, description, block.timestamp);
        emit ArcRuleDeclared(entryCount, principle, description);
    }
}
