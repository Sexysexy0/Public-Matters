// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IndieGameVault {
    address public developer;
    uint256 public totalFunded;
    uint256 public currentMilestone;
    
    mapping(address => uint256) public contributions;
    mapping(uint256 => bool) public milestoneApproved;

    event Funded(address indexed backer, uint256 amount);
    event MilestoneReleased(uint256 indexed milestoneId, uint256 amount);

    constructor(address _developer) {
        developer = _developer;
    }

    function fundProject() external payable {
        require(msg.value > 0, "Must send ETH");
        contributions[msg.sender] += msg.value;
        totalFunded += msg.value;
        emit Funded(msg.sender, msg.value);
    }

    function releaseMilestone(uint256 milestoneId, uint256 amount) external {
        require(msg.sender == developer, "Only developer");
        require(!milestoneApproved[milestoneId], "Milestone already paid");
        require(address(this).balance >= amount, "Insufficient vault balance");

        milestoneApproved[milestoneId] = true;
        currentMilestone = milestoneId;

        (bool success, ) = payable(developer).call{value: amount}(""); require(success, "Transfer failed");
        emit MilestoneReleased(milestoneId, amount);
    }
}
