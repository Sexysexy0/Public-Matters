pragma solidity ^0.8.20;

/// @title CapacityExpansionLedger
/// @notice Encodes governance for expanded lending capacity.
/// @dev Anchors charter amendments and disclosure scaling.

contract CapacityExpansionLedger {
    address public overseer;
    uint256 public entryCount;

    struct ExpansionRule {
        uint256 id;
        string principle;   // Charter, Lending, Disclosure
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ExpansionRule> public entries;
    event ExpansionRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareExpansionRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = ExpansionRule(entryCount, principle, description, block.timestamp);
        emit ExpansionRuleDeclared(entryCount, principle, description);
    }
}
