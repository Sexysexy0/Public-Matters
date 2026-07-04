// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LongHorizonCharter
/// @notice Encodes multi-year conviction and long-term holding rules.
/// @dev Anchors horizon discipline, thesis checkpoints, and structural reviews.

contract LongHorizonCharter {
    address public overseer;
    uint256 public charterRuleCount;

    struct CharterRule {
        uint256 id;
        string principle;   // Horizon, Discipline, Thesis
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CharterRule> public charterRules;
    event CharterRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareCharterRule(string calldata principle, string calldata description) external onlyOverseer {
        charterRuleCount++;
        charterRules[charterRuleCount] = CharterRule(charterRuleCount, principle, description, block.timestamp);
        emit CharterRuleDeclared(charterRuleCount, principle, description);
    }
}
