// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract QuestIntegrity {
    // [Goal: Filter out repetitive, low-value tasks that drain resources]
    function validateQuest(string memory _objective, bool _isHighValue) external pure returns (bool) {
        require(_isHighValue, "REJECTED: Objective is a low-value errand.");
        return true;
    }
}
