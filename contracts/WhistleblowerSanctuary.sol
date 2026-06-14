// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract WhistleblowerSanctuary {
    address public guardian;
    uint256 public totalReports;

    enum ReportStatus { Submitted, UnderReview, Validated, Rejected }

    struct IntelReport {
        uint256 id;
        bytes32 reportHash;       // Cryptographic footprint ng ebidensya (IPFS hash o encrypted text hash)
        address targetedInstitution; // Ang institusyong isinusumbong
        ReportStatus status;      // Kasalukuyang estado ng imbestigasyon
        uint256 timestamp;        // Oras ng pagpasa
        string statusLog;         // Pormal na tala ng Guardian ukol sa status
    }

    mapping(uint256 => IntelReport) public reports;
    mapping(bytes32 => bool) public registeredHashes;

    event ReportSubmitted(uint256 indexed reportId, bytes32 indexed reportHash, address indexed institution);
    event ReportStatusUpdated(uint256 indexed reportId, ReportStatus indexed newStatus, string comment);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Error: Sanctuary denial. Only the Sovereign Guardian can update registry metrics.");
        _;
    }

    constructor() {
        guardian = msg.sender;
    }

    // Hakbang 1: Ligtas at anonymous na pagpasa ng ulat ng isang whistleblower
    function submitIntel(bytes32 _encryptedReportHash, address _targetedInstitution) public returns (uint256) {
        require(_targetedInstitution != address(0), "Error: Invalid institution target address.");
        require(!registeredHashes[_encryptedReportHash], "Error: This specific evidence cryptographic footprint already exists.");

        totalReports++;
        
        reports[totalReports] = IntelReport({
            id: totalReports,
            reportHash: _encryptedReportHash,
            targetedInstitution: _targetedInstitution,
            status: ReportStatus.Submitted,
            timestamp: block.timestamp,
            statusLog: "Initial encrypted intel submission logged successfully."
        });

        registeredHashes[_encryptedReportHash] = true;

        emit ReportSubmitted(totalReports, _encryptedReportHash, _targetedInstitution);
        return totalReports;
    }

    // Hakbang 2: Pagsusuri ng Guardian sa status ng ulat para sa structural accountability
    function updateReportStatus(
        uint256 _reportId, 
        ReportStatus _newStatus, 
        string memory _comment
    ) public onlyGuardian {
        require(_reportId > 0 && _reportId <= totalReports, "Error: Intel report ID context non-existent.");
        
        IntelReport storage report = reports[_reportId];
        report.status = _newStatus;
        report.statusLog = _comment;

        emit ReportStatusUpdated(_reportId, _newStatus, _comment);
    }

    // View function para sa pampublikong monitoring ng compliance at verification status
    function getReportMetrics(uint256 _reportId) public view returns (
        bytes32, 
        address, 
        ReportStatus, 
        uint256, 
        string memory
    ) {
        require(_reportId > 0 && _reportId <= totalReports, "Error: Invalid report ID.");
        IntelReport memory report = reports[_reportId];
        return (
            report.reportHash, 
            report.targetedInstitution, 
            report.status, 
            report.timestamp, 
            report.statusLog
        );
    }
}
