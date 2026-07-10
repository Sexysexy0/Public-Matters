// SPDX-License-Identifier: MIT
// Contract Name: CollectiveMemoryArchive
// Purpose: Preserve historical records and contributions in immutable archive
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract CollectiveMemoryArchive {
    address public chiefOperator;
    uint256 public recordCount;

    struct Record {
        string contributor;
        string content;
        uint256 timestamp;
    }

    Record[] public records;

    event RecordStored(string contributor, string content, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        recordCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Store new historical record
    function storeRecord(string memory contributor, string memory content) public onlyChief {
        records.push(Record(contributor, content, block.timestamp));
        recordCount++;
        emit RecordStored(contributor, content, block.timestamp);
    }

    // View record details
    function getRecord(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < records.length, "Invalid record index");
        Record memory r = records[index];
        return (r.contributor, r.content, r.timestamp);
    }
}
