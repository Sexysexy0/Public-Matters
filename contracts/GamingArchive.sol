// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GamingArchive
/// @notice Immutable ledger for GamingCouncil decisions and industry audits
/// @dev Stores permanent records of council votes and case resolutions

contract GamingArchive {
    address public archivist;
    uint256 public recordCount;

    struct ArchiveRecord {
        uint256 id;
        string category;   // e.g., "Council Decision", "Industry Audit", "Case Resolution"
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

    /// @notice Store a new council decision or audit
    /// @param category type of record
    /// @param content details of the decision or audit
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
