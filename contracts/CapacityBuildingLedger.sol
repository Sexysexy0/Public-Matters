// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CapacityBuildingLedger
/// @notice Ledger covenant to record training, faculty development, and industry orientation
contract CapacityBuildingLedger {
    address public overseer;
    uint256 public entryCount;

    struct CapacityRecord {
        uint256 id;
        string institution;   // university or ORIC name
        string activity;      // training, seminar, workshop
        string orientation;   // industry-linked, academic, hybrid
        string participants;  // faculty, students, staff
        string outcome;       // skills gained, partnerships formed
        string notes;         // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => CapacityRecord) public records;

    event CapacityLogged(uint256 indexed id, string institution, string activity, string orientation, string participants, string outcome, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs capacity building record
    function logCapacity(string calldata institution, string calldata activity, string calldata orientation, string calldata participants, string calldata outcome, string calldata notes) external onlyOverseer {
        entryCount++;
        records[entryCount] = CapacityRecord({
            id: entryCount,
            institution: institution,
            activity: activity,
            orientation: orientation,
            participants: participants,
            outcome: outcome,
            notes: notes,
            timestamp: block.timestamp
        });
        emit CapacityLogged(entryCount, institution, activity, orientation, participants, outcome, notes);
    }

    /// @notice Citizens can view capacity building records
    function viewCapacity(uint256 id) external view returns (CapacityRecord memory) {
        return records[id];
    }
}
