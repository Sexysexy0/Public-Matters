pragma solidity ^0.8.20;

contract AdaptiveImmersionLedger {
    address public overseer;
    uint256 public entryCount;

    struct ImmersionRule {
        uint256 id;
        string principle;   // Adaptive Immersion, Player Resonance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ImmersionRule) public entries;
    event ImmersionRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareImmersionRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = ImmersionRule(entryCount, principle, description, block.timestamp);
        emit ImmersionRuleDeclared(entryCount, principle, description);
    }
}
