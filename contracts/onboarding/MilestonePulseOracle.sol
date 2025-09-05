// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

contract MilestonePulseOracle {
    struct MilestonePulse {
        string milestone;
        uint256 emotionalAPR;
        bool masteryAchieved;
        string department;
        uint256 timestamp;
    }

    mapping(address => MilestonePulse[]) public milestoneLog;
    event MilestoneLogged(address indexed steward, string milestone, uint256 emotionalAPR, bool masteryAchieved, string department, uint256 timestamp);

    function logMilestone(address steward, string calldata milestone, uint256 apr, bool mastery, string calldata dept) external {
        require(apr >= 10, "Emotional APR too low");

        milestoneLog[steward].push(MilestonePulse(milestone, apr, mastery, dept, block.timestamp));
        emit MilestoneLogged(steward, milestone, apr, mastery, dept, block.timestamp);
    }

    function getLatestMilestone(address steward) external view returns (MilestonePulse memory) {
        uint256 len = milestoneLog[steward].length;
        require(len > 0, "No milestone recorded");
        return milestoneLog[steward][len - 1];
    }

    function getMilestoneCount(address steward) external view returns (uint256) {
        return milestoneLog[steward].length;
    }
}
