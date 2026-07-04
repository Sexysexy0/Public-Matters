// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SentimentCycleLedger
/// @notice Encodes sentiment cycle tracking rules.
/// @dev Anchors cycle classification, behavioral safeguards, and sentiment indicators.

contract SentimentCycleLedger {
    address public overseer;
    uint256 public cycleCount;

    struct SentimentCycle {
        uint256 id;
        string principle;   // Fear, Disbelief, Accumulation, Euphoria
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SentimentCycle> public cycles;
    event SentimentCycleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareSentimentCycle(string calldata principle, string calldata description) external onlyOverseer {
        cycleCount++;
        cycles[cycleCount] = SentimentCycle(cycleCount, principle, description, block.timestamp);
        emit SentimentCycleDeclared(cycleCount, principle, description);
    }
}
