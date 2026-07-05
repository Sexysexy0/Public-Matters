pragma solidity ^0.8.20;

/// @title CommunityCoolingLedger
/// @notice Covenant for local cooling projects.
/// @dev Anchors communal gardens, shade, and resilience.

contract CommunityCoolingLedger {
    address public overseer;
    uint256 public entryCount;

    struct CoolingRule {
        uint256 id;
        string principle;   // Community Cooling, Gardens, Resilience
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CoolingRule) public entries;
    event CoolingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCoolingRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = CoolingRule(entryCount, principle, description, block.timestamp);
        emit CoolingRuleDeclared(entryCount, principle, description);
    }
}
