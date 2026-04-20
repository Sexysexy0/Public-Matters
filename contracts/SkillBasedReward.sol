// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SkillBasedReward {
    // [Goal: Reward ONLY the Competent]
    function claimReward(uint256 _performanceScore) external {
        uint256 highThreshold = 90;
        require(_performanceScore >= highThreshold, "Git Gud: Score too low for reward.");
        // Action: Transfer value only to top-tier performers.
    }
}
