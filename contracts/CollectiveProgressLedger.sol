// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CollectiveProgressLedger {
    address public overseer;
    uint256 public milestoneCount;

    struct Milestone {
        uint256 id;
        string goal;   // Development, Education, Health
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Milestone) public milestones;
    event MilestoneRecorded(uint256 indexed id, string goal, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function recordMilestone(string calldata goal, string calldata description) external onlyOverseer {
        milestoneCount++;
        milestones[milestoneCount] = Milestone(milestoneCount, goal, description, block.timestamp);
        emit MilestoneRecorded(milestoneCount, goal, description);
    }
}
