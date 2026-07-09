// SPDX-License-Identifier: MIT
// Contract Name: DataTransparencyGrid
// Purpose: Unified reporting system for covenant outputs
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract DataTransparencyGrid {
    address public chiefOperator;
    uint256 public reportCount;

    struct Report {
        string covenantName;
        string outcome;
        string transparencyNote;
        uint256 timestamp;
    }

    Report[] public reports;

    event ReportAdded(string covenantName, string outcome, string transparencyNote, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        reportCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new transparency report
    function addReport(string memory covenantName, string memory outcome, string memory transparencyNote) public onlyChief {
        reports.push(Report(covenantName, outcome, transparencyNote, block.timestamp));
        reportCount++;
        emit ReportAdded(covenantName, outcome, transparencyNote, block.timestamp);
    }

    // View report details
    function getReport(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < reports.length, "Invalid report index");
        Report memory r = reports[index];
        return (r.covenantName, r.outcome, r.transparencyNote, r.timestamp);
    }
}
