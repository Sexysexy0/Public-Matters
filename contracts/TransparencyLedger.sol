pragma solidity ^0.8.20;

/// @title TransparencyLedger
/// @notice Encodes transparency and accountability principles.
/// @dev Anchors disclosure, access, and participation safeguards.

contract TransparencyLedger {
    address public overseer;
    uint256 public entryCount;

    struct TransparencyRule {
        uint256 id;
        string principle;   // Disclosure, Access, Participation
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => TransparencyRule> public entries;
    event TransparencyRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareTransparencyRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = TransparencyRule(entryCount, principle, description, block.timestamp);
        emit TransparencyRuleDeclared(entryCount, principle, description);
    }
}
