// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AccountabilityLedger {
    address public overseer;
    uint256 public recordCount;

    struct Record {
        uint256 id;
        string action;   // Decision, Policy, Program
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Record) public records;
    event RecordLogged(uint256 indexed id, string action, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function logRecord(string calldata action, string calldata description) external onlyOverseer {
        recordCount++;
        records[recordCount] = Record(recordCount, action, description, block.timestamp);
        emit RecordLogged(recordCount, action, description);
    }
}
