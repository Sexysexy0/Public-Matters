// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SenateArchive
/// @notice Immutable ledger for SenateCouncil decisions and quorum audits
/// @dev Stores permanent records of council votes, boycott resolutions, and governance audits

contract SenateArchive {
    address public archivist;
    uint256 public recordCount;

    struct ArchiveRecord {
        uint256 id;
        string category;   // e.g., "Council Decision", "Quorum Audit", "Boycott Resolution"
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

    /// @notice Store a new council decision, quorum audit, or boycott resolution
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
