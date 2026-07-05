pragma solidity ^0.8.20;

/// @title HumanOverrideLedger
/// @notice Encodes human override rights across AI systems.
/// @dev Anchors appeal, override, and accountability safeguards.

contract HumanOverrideLedger {
    address public overseer;
    uint256 public entryCount;

    struct OverrideRule {
        uint256 id;
        string principle;   // Appeal, Override, Accountability
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => OverrideRule> public entries;
    event OverrideRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareOverrideRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = OverrideRule(entryCount, principle, description, block.timestamp);
        emit OverrideRuleDeclared(entryCount, principle, description);
    }
}
