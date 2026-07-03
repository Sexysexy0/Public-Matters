// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunityFeedbackCodex {
    address public overseer;
    uint256 public feedbackCount;

    struct FeedbackRule {
        uint256 id;
        string principle; // Player Voice, Iterative Balancing, Transparency, Responsiveness
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => FeedbackRule) public feedbacks;

    event FeedbackLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logFeedback(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        feedbackCount++;
        feedbacks[feedbackCount] = FeedbackRule({
            id: feedbackCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit FeedbackLogged(feedbackCount, principle, description);
    }

    function viewFeedback(uint256 id) external view returns (FeedbackRule memory) {
        return feedbacks[id];
    }
}
