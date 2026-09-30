// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

/**
 * @title MicroGridTracker
 * @notice Transparent milestone and cost tracking for barangay-level micro-grid utility projects.
 * @dev Designed for EVM osaka & Foundry pipelines (viaIR compatible).
 */
contract MicroGridTracker {
    struct Milestone {
        string description;
        uint256 targetBudget;
        uint256 actualSpent;
        bool isCompleted;
        uint256 timestamp;
    }

    address public owner;
    string public barangayLocation;
    mapping(uint256 => Milestone) public milestones;
    uint256 public milestoneCount;

    event MilestoneAdded(uint256 indexed id, string description, uint256 targetBudget);
    event MilestoneCompleted(uint256 indexed id, uint256 actualSpent, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized: Caller is not the project authority");
        _;
    }

    constructor(string memory _barangayLocation) {
        owner = msg.sender;
        barangayLocation = _barangayLocation;
    }

    function addMilestone(string calldata _description, uint256 _targetBudget) external onlyOwner {
        milestones[milestoneCount] = Milestone({
            description: _description,
            targetBudget: _targetBudget,
            actualSpent: 0,
            isCompleted: false,
            timestamp: 0
        });
        emit MilestoneAdded(milestoneCount, _description, _targetBudget);
        milestoneCount++;
    }

    function completeMilestone(uint256 _id, uint256 _actualSpent) external onlyOwner {
        require(_id < milestoneCount, "Milestone does not exist");
        require(!milestones[_id].isCompleted, "Milestone already completed");

        Milestone storage m = milestones[_id];
        m.actualSpent = _actualSpent;
        m.isCompleted = true;
        m.timestamp = block.timestamp;

        emit MilestoneCompleted(_id, _actualSpent, block.timestamp);
    }
}
