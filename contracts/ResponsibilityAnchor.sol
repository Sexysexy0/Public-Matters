// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ResponsibilityAnchor
/// @notice Anchor covenant for voluntary responsibility safeguard
contract ResponsibilityAnchor {
    address public oversightCommittee;
    uint256 public anchorCount;

    struct ResponsibilityRecord {
        uint256 id;
        string principle;   // e.g. competence, honesty, cooperation
        string status;      // active, deprecated
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => ResponsibilityRecord) public anchors;

    event ResponsibilityAnchored(uint256 indexed id, string principle, string status, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight anchors a responsibility principle
    function anchorPrinciple(string calldata principle, string calldata notes) external onlyOversight {
        anchorCount++;
        anchors[anchorCount] = ResponsibilityRecord({
            id: anchorCount,
            principle: principle,
            status: "active",
            notes: notes,
            timestamp: block.timestamp
        });
        emit ResponsibilityAnchored(anchorCount, principle, "active", notes);
    }

    /// @notice Oversight deactivates a responsibility principle
    function deactivatePrinciple(uint256 id) external onlyOversight {
        anchors[id].status = "deprecated";
        emit ResponsibilityAnchored(id, anchors[id].principle, "deprecated", anchors[id].notes);
    }

    /// @notice Citizens can view responsibility anchors
    function viewAnchor(uint256 id) external view returns (ResponsibilityRecord memory) {
        return anchors[id];
    }
}
