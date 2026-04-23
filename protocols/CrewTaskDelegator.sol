// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CrewTaskDelegator {
    // [Goal: Automate tedious gathering via NPC assignments]
    function assignToFort(string memory _jobType, uint256 _npcCount) external pure returns (uint256) {
        // Higher NPC count = faster resource generation per hour
        return _npcCount * 15; // Returns yield per cycle
    }
}
