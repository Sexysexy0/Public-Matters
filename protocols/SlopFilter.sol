// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SlopFilter {
    // [Goal: Identify and remove 'chore' tasks that slow down the main career progression]
    function filterSlop(string memory _task, bool _isCore) external pure returns (string memory) {
        if (!_isCore) return "REJECTED: Feature Slop detected. Focus on Core Gameplay.";
        return "ACCEPTED: Critical path item.";
    }
}
