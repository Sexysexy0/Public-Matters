// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAuditHistory {
    function logHistoricalAction(
        address _institution,
        uint256 _freezeCount,
        uint256 _grantCount,
        uint256 _warningCount,
        bytes32 _actionLog
    ) external;
}

contract WhistleblowerSanctuary {
    address public guardian;
    uint256 public totalReports;
    IAuditHistory public auditHistory; // Reference sa master record ledger

    enum ReportStatus { Submitted, UnderReview, Validated, Rejected }

    struct IntelReport {
        uint256 id;
        bytes32 reportHash;          
        address targetedInstitution; 
        ReportStatus status;         
        uint256 timestamp;           
        bytes32 statusLog;           
    }

    mapping(uint256 => IntelReport) public reports;
    mapping(bytes32 => bool) public registeredHashes;

    event ReportSubmitted(uint256 indexed reportId, bytes32 indexed reportHash, address indexed institution);
    event ReportStatusUpdated(uint256 indexed reportId, ReportStatus indexed newStatus, bytes32 comment);
    event AuditHistoryAddressUpdated(address indexed newAddress);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Error: Sanctuary denial. Only the Sovereign Guardian can update registry metrics.");
        _;
    }

    constructor() {
        guardian = msg.sender;
    }

    // Pormal na pagkakabit ng Audit History contract target
    function setAuditHistoryAddress(address _auditHistoryAddress) public onlyGuardian {
        auditHistory = IAuditHistory(_auditHistoryAddress);
        emit AuditHistoryAddressUpdated(_auditHistoryAddress);
    }

    function submitIntel(bytes32 _encryptedReportHash, address _targetedInstitution) public returns (uint256) {
        require(_targetedInstitution != address(0), "Error: Invalid institution target address.");
        require(!registeredHashes[_encryptedReportHash], "Error: This specific evidence cryptographic footprint already exists.");

        totalReports++;
        bytes32 initialStatus = "STATUS_LOG_SUBMITTED";

        reports[totalReports] = IntelReport({
            id: totalReports,
            reportHash: _encryptedReportHash,
            targetedInstitution: _targetedInstitution,
            status: ReportStatus.Submitted,
            timestamp: block.timestamp,
            statusLog: initialStatus
        });

        registeredHashes[_encryptedReportHash] = true;

        emit ReportSubmitted(totalReports, _encryptedReportHash, _targetedInstitution);

        // CROSS-CONTRACT AUTOMATION: Mag-iwan ng selyo ng Warning sa pinag-isang kasaysayan
        if (address(auditHistory) != address(0)) {
            try auditHistory.logHistoricalAction(_targetedInstitution, 0, 0, 1, "INTEL_REPORT_FILED") {} catch {}
        }

        return totalReports;
    }

    function updateReportStatus(uint256 _reportId, ReportStatus _newStatus, bytes32 _comment) public onlyGuardian {
        require(_reportId > 0 && _reportId <= totalReports, "Error: Intel report ID context non-existent.");
        IntelReport storage report = reports[_reportId];
        report.status = _newStatus;
        report.statusLog = _comment;
        emit ReportStatusUpdated(_reportId, _newStatus, _comment);
    }

    function getReportMetrics(uint256 _reportId) public view returns (bytes32, address, ReportStatus, uint256, bytes32) {
        require(_reportId > 0 && _reportId <= totalReports, "Error: Invalid report ID.");
        IntelReport memory report = reports[_reportId];
        return (report.reportHash, report.targetedInstitution, report.status, report.timestamp, report.statusLog);
    }
}
