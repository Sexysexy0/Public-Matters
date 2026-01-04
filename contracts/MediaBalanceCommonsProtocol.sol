pragma solidity ^0.8.20;

contract MediaBalanceCommonsProtocol {
    address public admin;

    struct Report {
        string outlet;       // e.g. TV station, online site
        string topic;        // e.g. health, politics, economy
        string balance;      // Balanced, Biased, Solution-driven
        uint256 timestamp;
    }

    Report[] public reports;

    event ReportLogged(string outlet, string topic, string balance, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logReport(string calldata outlet, string calldata topic, string calldata balance) external onlyAdmin {
        reports.push(Report(outlet, topic, balance, block.timestamp));
        emit ReportLogged(outlet, topic, balance, block.timestamp);
    }

    function totalReports() external view returns (uint256) {
        return reports.length;
    }
}
