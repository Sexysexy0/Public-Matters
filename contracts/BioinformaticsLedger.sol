pragma solidity ^0.8.20;

/// @title BioinformaticsLedger
/// @notice Encodes information theory applied to biology.
/// @dev Anchors genomics, computational biology, and data-driven health.

contract BioinformaticsLedger {
    address public overseer;
    uint256 public entryCount;

    struct BioRule {
        uint256 id;
        string principle;   // Genomics, Data, Biology
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => BioRule> public entries;
    event BioRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareBioRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = BioRule(entryCount, principle, description, block.timestamp);
        emit BioRuleDeclared(entryCount, principle, description);
    }
}
