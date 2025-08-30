// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title SpeechAuditSuite
/// @notice Tracks suppression attempts, emotional tag integrity, and broadcast anomalies
contract SpeechAuditSuite {
    address public steward;
    mapping(address => uint256) public suppressionReports;
    mapping(address => string[]) public auditNotes;

    event SuppressionReported(address indexed vendor, string reason);
    event AuditNoteLogged(address indexed vendor, string note);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function reportSuppression(address vendor, string memory reason) external onlySteward {
        suppressionReports[vendor]++;
        emit SuppressionReported(vendor, reason);
    }

    function logAuditNote(address vendor, string memory note) external onlySteward {
        auditNotes[vendor].push(note);
        emit AuditNoteLogged(vendor, note);
    }

    function getAuditNotes(address vendor) external view returns (string[] memory) {
        return auditNotes[vendor];
    }
}
