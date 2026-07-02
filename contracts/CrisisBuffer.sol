// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CrisisBuffer {
    address public overseer;
    uint256 public bufferCount;

    struct Buffer {
        uint256 id;
        string measure;
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Buffer) public buffers;
    event BufferActivated(uint256 indexed id, string measure, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function activateBuffer(string calldata measure, string calldata description) external onlyOverseer {
        bufferCount++;
        buffers[bufferCount] = Buffer(bufferCount, measure, description, block.timestamp);
        emit BufferActivated(bufferCount, measure, description);
    }
}
