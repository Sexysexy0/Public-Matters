// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title StreamerBondPrototype
 * @dev Prototype covenant contract to safeguard streamer-friendly game design.
 * Arc: gameplay depth → humor resonance → balanced representation → community feedback
 */
contract StreamerBondPrototype {
    address public steward;
    mapping(address => bool) public approvedStreamers;
    mapping(string => uint256) public feedbackScores;

    event StreamerApproved(address streamer);
    event FeedbackSubmitted(address streamer, string category, uint256 score);
    event MemeResonance(address streamer, string memeLine);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    /// @dev Approve a streamer to participate in covenant feedback
    function approveStreamer(address _streamer) external onlySteward {
        approvedStreamers[_streamer] = true;
        emit StreamerApproved(_streamer);
    }

    /// @dev Submit feedback score for a category (e.g. "GameplayDepth", "HumorResonance")
    function submitFeedback(string calldata category, uint256 score) external {
        require(approvedStreamers[msg.sender], "Streamer not approved");
        feedbackScores[category] += score;
        emit FeedbackSubmitted(msg.sender, category, score);
    }

    /// @dev Encode meme resonance into covenant logs
    function dropMeme(string calldata memeLine) external {
        require(approvedStreamers[msg.sender], "Streamer not approved");
        emit MemeResonance(msg.sender, memeLine);
    }

    /// @dev Steward can reset feedback scores if arc needs recalibration
    function resetFeedback(string calldata category) external onlySteward {
        feedbackScores[category] = 0;
    }
}
