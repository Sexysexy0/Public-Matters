// contracts/BalancedCoverage.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title BalancedCoverage
 * @notice Logs media reports and communal equity in coverage balance.
 */
contract BalancedCoverage {
    address public admin;

    struct Report {
        string outlet;      // "NewsSiteX", "ChannelY"
        string topic;       // "Politics", "Economy", "Health"
        string verdict;     // "Balanced", "Biased"
        uint256 timestamp;
    }

    Report[] public reports;

    event ReportLogged(string outlet, string topic, string verdict, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logReport(string calldata outlet, string calldata topic, string calldata verdict) external onlyAdmin {
        reports.push(Report(outlet, topic, verdict, block.timestamp));
        emit ReportLogged(outlet, topic, verdict, block.timestamp);
    }

    function totalReports() external view returns (uint256) { return reports.length; }

    function getReport(uint256 id) external view returns (Report memory) {
        require(id < reports.length, "Invalid id");
        return reports[id];
    }
}
