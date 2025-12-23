// contracts/CryptoPulse.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CryptoPulse
 * @notice Logs macro data errors, inflation reports, and communal impact on crypto markets.
 */
contract CryptoPulse {
    address public admin;

    struct Report {
        string category;   // "Inflation", "FedRateCut", "CPIError"
        string description;
        uint256 value;
        uint256 timestamp;
    }

    Report[] public reports;

    event ReportLogged(string category, string description, uint256 value, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logReport(string calldata category, string calldata description, uint256 value) external onlyAdmin {
        reports.push(Report(category, description, value, block.timestamp));
        emit ReportLogged(category, description, value, block.timestamp);
    }

    function totalReports() external view returns (uint256) { return reports.length; }

    function getReport(uint256 id) external view returns (Report memory) {
        require(id < reports.length, "Invalid id");
        return reports[id];
    }
}
