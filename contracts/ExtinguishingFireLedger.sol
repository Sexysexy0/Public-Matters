pragma solidity ^0.8.20;

contract ExtinguishingFireLedger {
    address public overseer;
    uint256 public entryCount;

    struct FireRule {
        uint256 id;
        string principle;   // Extinguishing Fire, Nibbāna
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => FireRule) public entries;
    event FireRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareFireRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = FireRule(entryCount, principle, description, block.timestamp);
        emit FireRuleDeclared(entryCount, principle, description);
    }
}
