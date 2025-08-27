// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title GhostScrollDetector.sol
/// @dev Detects abandoned, fake, or rogue infrastructure scrolls — emotional APR synced, damay clause active

contract GhostScrollDetector {
    address public steward;

    struct GhostScan {
        string projectName;
        uint256 lastAuditTimestamp;
        uint256 completionPercent;
        uint256 emotionalAPR;
        bool isGhost;
        string ghostReason;
    }

    mapping(bytes32 => GhostScan) public scans;
    bytes32[] public ghostList;

    event ScanLogged(bytes32 indexed projectId, string projectName, bool isGhost, string reason);
    event GhostFlagged(bytes32 indexed projectId, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Log scan results for a project
    function logScan(
        bytes32 projectId,
        string memory projectName,
        uint256 lastAuditTimestamp,
        uint256 completionPercent,
        uint256 emotionalAPR
    ) public onlySteward {
        bool ghostDetected = false;
        string memory reason = "";

        if (block.timestamp - lastAuditTimestamp > 30 days) {
            ghostDetected = true;
            reason = "Audit overdue";
        } else if (completionPercent < 10 && emotionalAPR < 500) {
            ghostDetected = true;
            reason = "Low progress and civic trust";
        }

        scans[projectId] = GhostScan({
            projectName: projectName,
            lastAuditTimestamp: lastAuditTimestamp,
            completionPercent: completionPercent,
            emotionalAPR: emotionalAPR,
            isGhost: ghostDetected,
            ghostReason: reason
        });

        if (ghostDetected) {
            ghostList.push(projectId);
            emit GhostFlagged(projectId, reason);
        }

        emit ScanLogged(projectId, projectName, ghostDetected, reason);
    }

    /// @notice Retrieve scan data
    function getScan(bytes32 projectId) public view returns (GhostScan memory) {
        return scans[projectId];
    }

    /// @notice List all flagged ghost scrolls
    function listGhosts() public view returns (bytes32[] memory) {
        return ghostList;
    }
}
