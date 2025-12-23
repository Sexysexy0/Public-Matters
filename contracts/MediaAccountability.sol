// contracts/MediaAccountability.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MediaAccountability
 * @notice Logs media reports, bias ratings, and communal verdicts for balanced coverage.
 */
contract MediaAccountability {
    address public admin;

    struct Report {
        string outlet;
        string topic;
        string bias;       // "Neutral", "Positive", "Negative"
        uint256 timestamp;
    }

    Report[] public reports;

    event ReportLogged(string outlet, string topic, string bias, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logReport(string calldata outlet, string calldata topic, string calldata bias) external onlyAdmin {
        reports.push(Report(outlet, topic, bias, block.timestamp));
        emit ReportLogged(outlet, topic, bias, block.timestamp);
    }

    function totalReports() external view returns (uint256) { return reports.length; }

    function getReport(uint256 id) external view returns (Report memory) {
        require(id < reports.length, "Invalid id");
        return reports[id];
    }
}
