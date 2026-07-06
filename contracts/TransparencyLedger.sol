// SPDX-License-Identifier: MIT
// Contract Name: TransparencyLedger
// Purpose: Public reporting of SAVE Act enforcement events
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract TransparencyLedger {
    address public chiefOperator;
    uint256 public reportCount;

    struct Report {
        string provision;
        bool status;
        uint256 timestamp;
    }

    Report[] public reports;

    event ReportPublished(string provision, bool status, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        reportCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function publishReport(string memory provision, bool status) public onlyChief {
        reports.push(Report(provision, status, block.timestamp));
        reportCount++;
        emit ReportPublished(provision, status, block.timestamp);
    }

    function getReport(uint256 index) public view returns (string memory, bool, uint256) {
        require(index < reports.length, "Invalid report index");
        Report memory r = reports[index];
        return (r.provision, r.status, r.timestamp);
    }
}
