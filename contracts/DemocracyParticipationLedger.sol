// SPDX-License-Identifier: MIT
// Contract Name: DemocracyParticipationLedger
// Purpose: Record civic engagement and turnout metrics as trust indicators
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract DemocracyParticipationLedger {
    address public chiefOperator;
    uint256 public entryCount;

    struct Entry {
        string activity;
        uint256 participants;
        uint256 timestamp;
    }

    Entry[] public entries;

    event EntryAdded(string activity, uint256 participants, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        entryCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new participation entry
    function addEntry(string memory activity, uint256 participants) public onlyChief {
        entries.push(Entry(activity, participants, block.timestamp));
        entryCount++;
        emit EntryAdded(activity, participants, block.timestamp);
    }

    // View participation entry details
    function getEntry(uint256 index) public view returns (string memory, uint256, uint256) {
        require(index < entries.length, "Invalid entry index");
        Entry memory e = entries[index];
        return (e.activity, e.participants, e.timestamp);
    }
}
