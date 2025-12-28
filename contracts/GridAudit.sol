// contracts/GridAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title GridAudit
 * @notice Tracks energy grid performance and communal audit of resilience.
 */
contract GridAudit {
    address public admin;

    struct Report {
        string region;      // "Luzon", "Visayas", "Mindanao"
        string status;      // "Stable", "Overloaded", "Blackout"
        uint256 timestamp;
    }

    Report[] public reports;

    event ReportLogged(string region, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logReport(string calldata region, string calldata status) external onlyAdmin {
        reports.push(Report(region, status, block.timestamp));
        emit ReportLogged(region, status, block.timestamp);
    }

    function totalReports() external view returns (uint256) { return reports.length; }

    function getReport(uint256 id) external view returns (Report memory) {
        require(id < reports.length, "Invalid id");
        return reports[id];
    }
}
