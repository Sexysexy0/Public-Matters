// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PhilosophyArchive
/// @notice Immutable ledger for council decisions and study recommendations
/// @dev Stores permanent records of PhilosophyCouncil votes and Machiavelli study guidance

contract PhilosophyArchive {
    address public archivist;
    uint256 public recordCount;

    struct ArchiveRecord {
        uint256 id;
        string category;   // e.g., "Council Decision", "Study Recommendation"
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

    /// @notice Store a new council decision or study recommendation
    /// @param category type of record
    /// @param content details of the decision or recommendation
    function storeRecord(string calldata category, string calldata content) external onlyArchivist {
        recordCount++;
        records[recordCount] = ArchiveRecord(recordCount, category, content, block.timestamp);
        emit RecordStored(recordCount, category, content, block.timestamp);
    }

    /// @notice Retrieve a record by ID
    /// @param id identifier of the record
    /// @return full archive record struct
    function getRecord(uint256 id) external view returns (ArchiveRecord memory) {
        return records[id];
    }
}
