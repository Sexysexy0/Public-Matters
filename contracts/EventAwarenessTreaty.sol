// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EventAwarenessTreaty
/// @notice Encodes awareness rules for BTC macro events and structural signals.
/// @dev Anchors halving cycles, ETF flows, regulatory events, and liquidity triggers.

contract EventAwarenessTreaty {
    address public overseer;
    uint256 public eventRuleCount;

    struct EventRule {
        uint256 id;
        string principle;   // Halving, ETF flows, Regulation, Liquidity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => EventRule> public eventRules;
    event EventRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareEventRule(string calldata principle, string calldata description) external onlyOverseer {
        eventRuleCount++;
        eventRules[eventRuleCount] = EventRule(eventRuleCount, principle, description, block.timestamp);
        emit EventRuleDeclared(eventRuleCount, principle, description);
    }
}
