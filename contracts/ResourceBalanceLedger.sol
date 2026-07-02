// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ResourceBalanceLedger {
    address public overseer;
    uint256 public recordCount;

    struct Record {
        uint256 id;
        string resource;   // Energy, Food, Water
        string allocation;
        uint256 timestamp;
    }

    mapping(uint256 => Record) public records;
    event ResourceAllocated(uint256 indexed id, string resource, string allocation);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function allocateResource(string calldata resource, string calldata allocation) external onlyOverseer {
        recordCount++;
        records[recordCount] = Record(recordCount, resource, allocation, block.timestamp);
        emit ResourceAllocated(recordCount, resource, allocation);
    }
}
