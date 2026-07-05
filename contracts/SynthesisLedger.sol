pragma solidity ^0.8.20;

contract SynthesisLedger {
    address public overseer;
    uint256 public entryCount;

    struct SynthesisRule {
        uint256 id;
        string principle;   // Integration, Harmony, Diversity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SynthesisRule) public entries;
    event SynthesisRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSynthesisRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = SynthesisRule(entryCount, principle, description, block.timestamp);
        emit SynthesisRuleDeclared(entryCount, principle, description);
    }
}
