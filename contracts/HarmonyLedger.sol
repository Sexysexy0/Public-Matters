pragma solidity ^0.8.20;

contract HarmonyLedger {
    address public overseer;
    uint256 public entryCount;

    struct HarmonyRule {
        uint256 id;
        string principle;   // Harmony, Coherence
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => HarmonyRule) public entries;
    event HarmonyRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareHarmonyRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = HarmonyRule(entryCount, principle, description, block.timestamp);
        emit HarmonyRuleDeclared(entryCount, principle, description);
    }
}
