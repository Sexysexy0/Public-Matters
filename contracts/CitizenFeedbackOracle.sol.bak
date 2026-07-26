// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CitizenFeedbackOracle
/// @notice Covenant contract to encode citizen feedback on policy reforms
contract CitizenFeedbackOracle {
    address public overseer;
    uint256 public feedbackCount;

    struct FeedbackEntry {
        uint256 id;
        string policyName;
        address citizen;
        uint8 rating;
        string comments;
        uint256 timestamp;
    }

    mapping(uint256 => FeedbackEntry) public feedbacks;

    event FeedbackLogged(uint256 indexed id, string policyName, address citizen, uint8 rating, string comments);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logFeedback(
        string calldata policyName,
        uint8 rating,
        string calldata comments
    ) external {
        require(rating >= 1 && rating <= 5, "Rating must be between 1 and 5");
        feedbackCount++;
        feedbacks[feedbackCount] = FeedbackEntry({
            id: feedbackCount,
            policyName: policyName,
            citizen: msg.sender,
            rating: rating,
            comments: comments,
            timestamp: block.timestamp
        });
        emit FeedbackLogged(feedbackCount, policyName, msg.sender, rating, comments);
    }

    function viewFeedback(uint256 id) external view returns (FeedbackEntry memory) {
        return feedbacks[id];
    }
}
