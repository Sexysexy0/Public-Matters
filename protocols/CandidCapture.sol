// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CandidCapture
 * @dev Automatically logs key Sovereign milestones for historical persistence.
 */
contract CandidCapture {
    struct Milestone {
        uint256 timestamp;
        string action;
    }
    Milestone[] public history;

    // [Goal: Record candid proof of mastery without manual effort]
    function logMoment(string memory _action) external {
        history.push(Milestone(block.timestamp, _action));
    }
}
