// contracts/BalancedCoverage.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title BalancedCoverage
 * @notice Logs efforts to ensure balanced and reliable media coverage.
 */
contract BalancedCoverage {
    address public admin;

    struct Report {
        string topic;       // "Politics", "Economy", "Health"
        string status;      // "Balanced", "Biased"
        uint256 timestamp;
    }

    Report[] public reports;

    event ReportLogged(string topic, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logReport(string calldata topic, string calldata status) external onlyAdmin {
        reports.push(Report(topic, status, block.timestamp));
        emit ReportLogged(topic, status, block.timestamp);
    }

    function totalReports() external view returns (uint256) { return reports.length; }

    function getReport(uint256 id) external view returns (Report memory) {
        require(id < reports.length, "Invalid id");
        return reports[id];
    }
}
