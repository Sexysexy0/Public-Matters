// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ContinuitySentinel
/// @notice Sentinel safeguard for monitoring orchestration continuity
contract ContinuitySentinel {
    address public oversightCommittee;
    uint256 public sentinelCount;

    struct ContinuityRecord {
        uint256 id;
        string lane;        // e.g. business, movie, music, spiritual
        string status;      // stable, drift, unwanted
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => ContinuityRecord) public records;

    event ContinuityLogged(uint256 indexed id, string lane, string status, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight logs continuity status for a lane
    function logContinuity(string calldata lane, string calldata status, string calldata notes) external onlyOversight {
        sentinelCount++;
        records[sentinelCount] = ContinuityRecord({
            id: sentinelCount,
            lane: lane,
            status: status,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ContinuityLogged(sentinelCount, lane, status, notes);
    }

    /// @notice Citizens can view continuity records
    function viewContinuity(uint256 id) external view returns (ContinuityRecord memory) {
        return records[id];
    }
}
