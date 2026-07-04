// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MacroCycleLedger
/// @notice Encodes macro cycle awareness for portfolio governance.
/// @dev Anchors macro classification, stance rules, and review cadence.

contract MacroCycleLedger {
    address public overseer;
    uint256 public cycleCount;

    struct MacroCycle {
        uint256 id;
        string principle;   // Macro cycle, Liquidity, Rates
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => MacroCycle> public cycles;
    event MacroCycleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareMacroCycle(string calldata principle, string calldata description) external onlyOverseer {
        cycleCount++;
        cycles[cycleCount] = MacroCycle(cycleCount, principle, description, block.timestamp);
        emit MacroCycleDeclared(cycleCount, principle, description);
    }
}
