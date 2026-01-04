pragma solidity ^0.8.20;

contract CorruptionAuditProtocol {
    address public admin;

    struct Report {
        string official;
        string allegation;
        uint256 timestamp;
    }

    Report[] public reports;

    event ReportLogged(string official, string allegation, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logReport(string calldata official, string calldata allegation) external onlyAdmin {
        reports.push(Report(official, allegation, block.timestamp));
        emit ReportLogged(official, allegation, block.timestamp);
    }

    function totalReports() external view returns (uint256) {
        return reports.length;
    }
}
