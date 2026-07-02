// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UnityLedger {
    address public overseer;
    uint256 public entryCount;

    struct Entry {
        uint256 id;
        string milestone;
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Entry) public entries;
    event EntryRecorded(uint256 indexed id, string milestone, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function recordEntry(string calldata milestone, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = Entry(entryCount, milestone, description, block.timestamp);
        emit EntryRecorded(entryCount, milestone, description);
    }
}
