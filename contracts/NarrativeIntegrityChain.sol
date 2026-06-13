// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title NarrativeIntegrityChain
/// @notice Covenant to safeguard against manipulation tactics in storytelling
contract NarrativeIntegrityChain {
    address public oversightCommittee;
    uint256 public chainCount;

    struct NarrativeRecord {
        uint256 id;
        string category;     // e.g. business, spiritual, personal
        string contentHash;  // hash of narrative content
        string integrity;    // verified, flagged, removed
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => NarrativeRecord) public narratives;

    event NarrativeChecked(uint256 indexed id, string category, string integrity, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight logs narrative integrity check
    function logNarrative(string calldata category, string calldata contentHash, string calldata integrity, string calldata notes) external onlyOversight {
        chainCount++;
        narratives[chainCount] = NarrativeRecord({
            id: chainCount,
            category: category,
            contentHash: contentHash,
            integrity: integrity,
            notes: notes,
            timestamp: block.timestamp
        });
        emit NarrativeChecked(chainCount, category, integrity, notes);
    }

    /// @notice Citizens can view narrative integrity records
    function viewNarrative(uint256 id) external view returns (NarrativeRecord memory) {
        return narratives[id];
    }
}
