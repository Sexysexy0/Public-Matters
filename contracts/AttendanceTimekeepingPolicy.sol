// SPDX-License-Identifier: MIT
// Contract Name: AttendanceTimekeepingPolicy
// Purpose: Standardize attendance, timekeeping, and overtime rules
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract AttendanceTimekeepingPolicy {
    address public chiefOperator;
    uint256 public recordCount;

    struct Record {
        string principle;
        string guideline;
        uint256 timestamp;
    }

    Record[] public records;

    event RecordAdded(string principle, string guideline, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        recordCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new attendance/timekeeping clause
    function addRecord(string memory principle, string memory guideline) public onlyChief {
        records.push(Record(principle, guideline, block.timestamp));
        recordCount++;
        emit RecordAdded(principle, guideline, block.timestamp);
    }

    // View attendance/timekeeping clause details
    function getRecord(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < records.length, "Invalid record index");
        Record memory r = records[index];
        return (r.principle, r.guideline, r.timestamp);
    }
}
