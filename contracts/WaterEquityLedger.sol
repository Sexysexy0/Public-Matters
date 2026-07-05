pragma solidity ^0.8.20;

/// @title WaterEquityLedger
/// @notice Covenant for equitable water distribution.
/// @dev Anchors equity, sustainability, and resilience.

contract WaterEquityLedger {
    address public overseer;
    uint256 public entryCount;

    struct WaterRule {
        uint256 id;
        string principle;   // Water Equity, Sustainability, Fairness
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => WaterRule) public entries;
    event WaterRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareWaterRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = WaterRule(entryCount, principle, description, block.timestamp);
        emit WaterRuleDeclared(entryCount, principle, description);
    }
}
