// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MilestoneCodex {
    address public overseer;
    uint256 public milestoneCount;

    struct MilestoneRule {
        uint256 id;
        string principle; // Alpha Stability, Beta Readiness, Release Integrity, Post-Launch Support
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => MilestoneRule) public milestones;

    event MilestoneLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logMilestone(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        milestoneCount++;
        milestones[milestoneCount] = MilestoneRule({
            id: milestoneCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit MilestoneLogged(milestoneCount, principle, description);
    }

    function viewMilestone(uint256 id) external view returns (MilestoneRule memory) {
        return milestones[id];
    }
}
