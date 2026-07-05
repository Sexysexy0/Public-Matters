pragma solidity ^0.8.20;

/// @title BrainInterfaceLedger
/// @notice Encodes human-brain interface governance rules.
/// @dev Anchors neurotech, BCI, and ethical safeguards.

contract BrainInterfaceLedger {
    address public overseer;
    uint256 public entryCount;

    struct BrainRule {
        uint256 id;
        string principle;   // Neurotech, BCI, Ethics
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => BrainRule> public entries;
    event BrainRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareBrainRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = BrainRule(entryCount, principle, description, block.timestamp);
        emit BrainRuleDeclared(entryCount, principle, description);
    }
}
