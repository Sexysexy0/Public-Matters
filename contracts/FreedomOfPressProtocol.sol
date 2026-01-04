pragma solidity ^0.8.20;

contract FreedomOfPressProtocol {
    address public admin;

    struct Report {
        string outlet;       // e.g. newspaper, online site
        string issue;        // e.g. censorship, harassment, shutdown
        uint256 timestamp;
    }

    Report[] public reports;

    event ReportLogged(string outlet, string issue, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logReport(string calldata outlet, string calldata issue) external onlyAdmin {
        reports.push(Report(outlet, issue, block.timestamp));
        emit ReportLogged(outlet, issue, block.timestamp);
    }

    function totalReports() external view returns (uint256) {
        return reports.length;
    }
}
