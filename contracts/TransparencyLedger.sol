// SPDX-License-Identifier: MIT
// Contract Name: TransparencyLedger
// Purpose: Record governance actions in a tamper-proof ledger
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract TransparencyLedger {
    address public chiefOperator;
    uint256 public recordCount;

    struct Record {
        string action;
        string actor;
        uint256 timestamp;
    }

    Record[] public records;

    event RecordAdded(string action, string actor, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        recordCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new governance record
    function addRecord(string memory action, string memory actor) public onlyChief {
        records.push(Record(action, actor, block.timestamp));
        recordCount++;
        emit RecordAdded(action, actor, block.timestamp);
    }

    // View governance record details
    function getRecord(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < records.length, "Invalid record index");
        Record memory r = records[index];
        return (r.action, r.actor, r.timestamp);
    }
}
