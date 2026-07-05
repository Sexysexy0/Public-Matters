pragma solidity ^0.8.20;

contract AlignedMomentumLedger {
    address public overseer;
    uint256 public entryCount;

    struct MomentumRule {
        uint256 id;
        string principle;   // Aligned Momentum, Unified Direction
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => MomentumRule) public entries;
    event MomentumRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareMomentumRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = MomentumRule(entryCount, principle, description, block.timestamp);
        emit MomentumRuleDeclared(entryCount, principle, description);
    }
}
