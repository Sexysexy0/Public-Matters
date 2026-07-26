// contracts/CivicFeedback.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CivicFeedback {
    struct Feedback {
        address citizen;
        string message;
        uint256 timestamp;
    }

    Feedback[] public feedbacks;
    event FeedbackLogged(address indexed citizen, string message, uint256 timestamp);

    function logFeedback(string calldata message) external {
        feedbacks.push(Feedback(msg.sender, message, block.timestamp));
        emit FeedbackLogged(msg.sender, message, block.timestamp);
    }

    function totalFeedbacks() external view returns (uint256) {
        return feedbacks.length;
    }
}
