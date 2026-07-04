pragma solidity ^0.8.20;

/// @title HumanRightsLedger
/// @notice Encodes covenant for human rights protection in AI era.
/// @dev Anchors dignity, equality, and safeguard rules.

contract HumanRightsLedger {
    address public overseer;
    uint256 public entryCount;

    struct RightsRule {
        uint256 id;
        string principle;   // Dignity, Equality, Safeguard
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => RightsRule> public entries;
    event RightsRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareRightsRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = RightsRule(entryCount, principle, description, block.timestamp);
        emit RightsRuleDeclared(entryCount, principle, description);
    }
}
