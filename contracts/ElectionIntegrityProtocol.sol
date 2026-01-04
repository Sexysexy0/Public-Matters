pragma solidity ^0.8.20;

contract ElectionIntegrityProtocol {
    address public admin;

    struct Report {
        string precinct;
        string issue;
        uint256 timestamp;
    }

    Report[] public reports;

    event ReportLogged(string precinct, string issue, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logReport(string calldata precinct, string calldata issue) external onlyAdmin {
        reports.push(Report(precinct, issue, block.timestamp));
        emit ReportLogged(precinct, issue, block.timestamp);
    }

    function totalReports() external view returns (uint256) {
        return reports.length;
    }
}
