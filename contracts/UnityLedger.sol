pragma solidity ^0.8.20;

contract UnityLedger {
    address public overseer;
    uint256 public entryCount;

    struct UnityRule {
        uint256 id;
        string principle;   // Solidarity, Collective Harmony, Coherence
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => UnityRule) public entries;
    event UnityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareUnityRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = UnityRule(entryCount, principle, description, block.timestamp);
        emit UnityRuleDeclared(entryCount, principle, description);
    }
}
