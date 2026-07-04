// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title RiskToleranceCodex
/// @notice Encodes the user's risk tolerance, drawdown limits, and behavioral rules.
/// @dev Anchors long-horizon conviction and structured high-risk tolerance.

contract RiskToleranceCodex {
    address public overseer;
    uint256 public ruleCount;

    struct Rule {
        uint256 id;
        string principle;   // Drawdown, Horizon, Volatility tolerance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Rule> public rules;
    event RuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareRule(string calldata principle, string calldata description) external onlyOverseer {
        ruleCount++;
        rules[ruleCount] = Rule(ruleCount, principle, description, block.timestamp);
        emit RuleDeclared(ruleCount, principle, description);
    }
}
