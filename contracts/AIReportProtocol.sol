pragma solidity ^0.8.20;

contract AIReportProtocol {
    address public admin;

    struct Report {
        string subject;      // e.g. Finance, Operations, Environment
        string summary;      // AI-generated independent report
        uint256 timestamp;
    }

    Report[] public reports;

    event ReportLogged(string subject, string summary, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logReport(string calldata subject, string calldata summary) external onlyAdmin {
        reports.push(Report(subject, summary, block.timestamp));
        emit ReportLogged(subject, summary, block.timestamp);
    }

    function totalReports() external view returns (uint256) {
        return reports.length;
    }
}
