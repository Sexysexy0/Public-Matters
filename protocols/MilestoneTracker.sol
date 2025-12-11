// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// MilestoneTracker: define milestones and mark completion
contract MilestoneTracker {
    struct Milestone {
        uint256 id;
        string name;        // e.g., "FGDs complete", "Street audits done"
        string docURI;      // terms of reference, outputs
        bool completed;
        uint256 timestamp;
    }

    address public steward;
    mapping(uint256 => Milestone) public milestones;
    uint256 public nextId;

    event MilestoneAdded(uint256 indexed id, string name);
    event MilestoneCompleted(uint256 indexed id);

    constructor() { steward = msg.sender; }

    function addMilestone(string calldata name, string calldata docURI) external {
        require(msg.sender == steward, "Only steward");
        milestones[nextId] = Milestone(nextId, name, docURI, false, block.timestamp);
        emit MilestoneAdded(nextId, name);
        nextId++;
    }

    function complete(uint256 id) external {
        require(msg.sender == steward, "Only steward");
        require(!milestones[id].completed, "Already completed");
        milestones[id].completed = true;
        emit MilestoneCompleted(id);
    }
}
