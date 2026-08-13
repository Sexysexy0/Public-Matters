// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TransparencyLedger {
    string[] private records;

    function logRecord(string memory record) public {
        records.push(record);
    }

    function getRecord(uint256 index) public view returns (string memory) {
        require(index < records.length, "Invalid index");
        return records[index];
    }

    function totalRecords() public view returns (uint256) {
        return records.length;
    }
}
