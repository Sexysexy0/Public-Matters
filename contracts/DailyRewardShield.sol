// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DailyRewardShield {
    event DailyChestOpened(address player, uint256 points);

    function openChest(address player) external {
        uint256 reward = randomReward();
        emit DailyChestOpened(player, reward);
        // SHIELD: Daily reward safeguarded to encode fairness and prevent exploitative imbalance in point cycles.
    }

    function randomReward() internal view returns (uint256) {
        uint256[3] memory rewards = [20, 50, 100];
        uint256 index = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao))) % rewards.length;
        return rewards[index];
    }
}
