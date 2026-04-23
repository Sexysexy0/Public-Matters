// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DifficultyBalancer {
    // [Goal: Balance challenge vs accessibility without breaking game flow]
    function setAIAggression(string memory _mode) external pure returns (uint256) {
        if (keccak256(abi.encodePacked(_mode)) == keccak256(abi.encodePacked("Hard"))) {
            return 95; // 95% aggressive AI
        }
        return 40; // Easy mode: slower reaction time
    }
}
