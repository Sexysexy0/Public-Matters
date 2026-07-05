pragma solidity ^0.8.20;

/// @title PerceptionEquityLedger
/// @notice Covenant for perception equity safeguards.
/// @dev Anchors awareness, justice, and communal fairness.

contract PerceptionEquityLedger {
    address public overseer;
    uint256 public entryCount;

    struct EquityRule {
        uint256 id;
        string principle;   // Perception Equity, Awareness, Justice
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => EquityRule) public entries;
    event EquityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareEquityRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = EquityRule(entryCount, principle, description, block.timestamp);
        emit EquityRuleDeclared(entryCount, principle, description);
    }
}
