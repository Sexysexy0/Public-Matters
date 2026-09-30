// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

/**
 * @title MicroGridTracker
 * @notice Transparent milestone, cost tracking, and direct community utility relief distribution
 *         for barangay-level micro-grid projects.
 * @dev Designed for institutional civic-tech infrastructure.
 */
contract MicroGridTracker {
    struct Milestone {
        string description;
        uint256 targetBudget;
        uint256 actualSpent;
        bool isCompleted;
        uint256 timestamp;
    }

    struct HouseholdRelief {
        uint256 subsidyAmount;
        bool claimed;
        uint256 disbursementTime;
    }

    address public owner;
    string public barangayLocation;
    
    mapping(uint256 => Milestone) public milestones;
    uint256 public milestoneCount;

    // Tracking direct utility cost relief distributed to community households
    mapping(address => HouseholdRelief) public reliefRegistry;
    uint256 public totalReliefDistributed;

    event MilestoneAdded(uint256 indexed id, string description, uint256 targetBudget);
    event MilestoneCompleted(uint256 indexed id, uint256 actualSpent, uint256 timestamp);
    event ReliefAllocated(address indexed household, uint256 amount);
    event ReliefClaimed(address indexed household, uint256 amount, uint256 timestamp);

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

    function allocateRelief(address _household, uint256 _amount) external onlyOwner {
        require(_household != address(0), "Invalid household address");
        reliefRegistry[_household] = HouseholdRelief({
            subsidyAmount: _amount,
            claimed: false,
            disbursementTime: 0
        });
        emit ReliefAllocated(_household, _amount);
    }

    function claimRelief() external {
        HouseholdRelief storage relief = reliefRegistry[msg.sender];
        require(relief.subsidyAmount > 0, "No relief allocated for this address");
        require(!relief.claimed, "Relief already claimed");

        relief.claimed = true;
        relief.disbursementTime = block.timestamp;
        totalReliefDistributed += relief.subsidyAmount;

        emit ReliefClaimed(msg.sender, relief.subsidyAmount, block.timestamp);
    }
}
