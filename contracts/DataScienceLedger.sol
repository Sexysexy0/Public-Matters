pragma solidity ^0.8.20;

/// @title DataScienceLedger
/// @notice Encodes data science integration rules.
/// @dev Anchors signal processing, information theory, and data-driven research.

contract DataScienceLedger {
    address public overseer;
    uint256 public entryCount;

    struct DataRule {
        uint256 id;
        string principle;   // Data, Signal, Information
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => DataRule> public entries;
    event DataRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareDataRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = DataRule(entryCount, principle, description, block.timestamp);
        emit DataRuleDeclared(entryCount, principle, description);
    }
}
