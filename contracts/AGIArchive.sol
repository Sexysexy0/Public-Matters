// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AGIArchive
/// @notice Immutable ledger for AGI council decisions and audits
/// @dev Stores permanent records of milestones, audits, and ethical checks

contract AGIArchive {
    address public archivist;
    uint256 public recordCount;

    struct ArchiveRecord {
        uint256 id;
        string category;   // e.g., "Milestone", "Disruption Audit", "Ethical Check", "Council Decision"
        string content;
        uint256 timestamp;
    }

    mapping(uint256 => ArchiveRecord) public records;

    event RecordStored(uint256 id, string category, string content, uint256 timestamp);

    modifier onlyArchivist() {
        require(msg.sender == archivist, "Not authorized");
        _;
    }

    constructor(address _archivist) {
        archivist = _archivist;
        recordCount = 0;
    }

    /// @notice Store a new record (milestone, audit, or council decision)
    function storeRecord(string calldata category, string calldata content) external onlyArchivist {
        recordCount++;
        records[recordCount] = ArchiveRecord(recordCount, category, content, block.timestamp);
        emit RecordStored(recordCount, category, content, block.timestamp);
    }

    /// @notice Retrieve a record by ID
    function getRecord(uint256 id) external view returns (ArchiveRecord memory) {
        return records[id];
    }
}
