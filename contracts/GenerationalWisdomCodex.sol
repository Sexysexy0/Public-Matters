// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GenerationalWisdomCodex {
    address public overseer;
    uint256 public entryCount;

    struct Entry {
        uint256 id;
        string domain;   // Elders, Youth, Continuity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Entry) public entries;
    event EntryDeclared(uint256 indexed id, string domain, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareEntry(string calldata domain, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = Entry(entryCount, domain, description, block.timestamp);
        emit EntryDeclared(entryCount, domain, description);
    }
}
