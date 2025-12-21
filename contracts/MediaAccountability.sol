// contracts/MediaAccountability.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MediaAccountability
 * @notice Balanced coverage, anti-disinformation, communal transparency, and narrative audit.
 */
contract MediaAccountability {
    address public admin;

    struct Report {
        string outlet;
        string topic;
        string status;   // "Balanced", "Biased", "Disinformation"
        string note;
        uint256 timestamp;
    }

    Report[] public reports;

    event ReportLogged(string outlet, string topic, string status, string note, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logReport(string calldata outlet, string calldata topic, string calldata status, string calldata note) external onlyAdmin {
        reports.push(Report(outlet, topic, status, note, block.timestamp));
        emit ReportLogged(outlet, topic, status, note, block.timestamp);
    }

    function totalReports() external view returns (uint256) {
        return reports.length;
    }

    function getReport(uint256 id) external view returns (Report memory) {
        require(id < reports.length, "Invalid id");
        return reports[id];
    }
}
