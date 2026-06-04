// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ImmutableRecords
/// @notice Covenant contract to store permanent, immutable records of DAO decisions
contract ImmutableRecords {
    address public owner;

    struct Record {
        string decision;     // e.g. "Proposal Passed", "Safeguard Adopted"
        string context;      // description of the decision
        uint256 timestamp;
    }

    Record[] public records;

    event RecordLogged(string decision, string context, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function logRecord(string memory decision, string memory context) public onlyOwner {
        Record memory newRecord = Record(decision, context, block.timestamp);
        records.push(newRecord);
        emit RecordLogged(decision, context, block.timestamp);
    }

    function getRecord(uint256 index) public view returns (string memory, string memory, uint256) {
        Record memory r = records[index];
        return (r.decision, r.context, r.timestamp);
    }

    function getRecordCount() public view returns (uint256) {
        return records.length;
    }
}
