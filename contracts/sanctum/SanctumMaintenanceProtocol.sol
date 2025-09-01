// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SanctumMaintenanceProtocol {
    struct MaintenanceLog {
        string unitID;
        string barangay;
        string issueReported;
        string emotionalTag; // "MercyPing", "AuditGlow", "SanctumGlow"
        uint256 reportTimestamp;
        bool isResolved;
    }

    mapping(string => MaintenanceLog[]) public maintenanceRecords;

    event MaintenanceReported(string unitID, string issueReported, string emotionalTag, uint256 reportTimestamp);
    event MaintenanceResolved(string unitID, uint256 resolutionTimestamp);

    function reportIssue(
        string memory _unitID,
        string memory _barangay,
        string memory _issueReported,
        string memory _emotionalTag
    ) public {
        maintenanceRecords[_unitID].push(MaintenanceLog({
            unitID: _unitID,
            barangay: _barangay,
            issueReported: _issueReported,
            emotionalTag: _emotionalTag,
            reportTimestamp: block.timestamp,
            isResolved: false
        }));

        emit MaintenanceReported(_unitID, _issueReported, _emotionalTag, block.timestamp);
    }

    function resolveIssue(string memory _unitID, uint256 _index) public {
        maintenanceRecords[_unitID][_index].isResolved = true;
        emit MaintenanceResolved(_unitID, block.timestamp);
    }

    function getMaintenanceLogs(string memory _unitID) public view returns (MaintenanceLog[] memory) {
        return maintenanceRecords[_unitID];
    }
}
