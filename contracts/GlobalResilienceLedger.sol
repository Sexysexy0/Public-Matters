// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GlobalResilienceLedger {
    address public overseer;
    uint256 public recordCount;

    struct Record {
        uint256 id;
        string initiative;   // Disaster Preparedness, Crisis Response
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Record) public records;
    event RecordDeclared(uint256 indexed id, string initiative, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareRecord(string calldata initiative, string calldata description) external onlyOverseer {
        recordCount++;
        records[recordCount] = Record(recordCount, initiative, description, block.timestamp);
        emit RecordDeclared(recordCount, initiative, description);
    }
}
