// SPDX-License-Identifier: MIT
// Contract Name: TransparencyLedgerProtocol
// Purpose: Ensure visibility of fund transfers and indirect shares
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract TransparencyLedgerProtocol {
    address public chiefOperator;
    uint256 public recordCount;

    struct Record {
        string transactionType;
        string visibilityRule;
        uint256 timestamp;
    }

    Record[] public records;

    event RecordLogged(string transactionType, string visibilityRule, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        recordCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Log new transparency record
    function logRecord(string memory transactionType, string memory visibilityRule) public onlyChief {
        records.push(Record(transactionType, visibilityRule, block.timestamp));
        recordCount++;
        emit RecordLogged(transactionType, visibilityRule, block.timestamp);
    }

    // View record details
    function getRecord(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < records.length, "Invalid record index");
        Record memory r = records[index];
        return (r.transactionType, r.visibilityRule, r.timestamp);
    }
}
