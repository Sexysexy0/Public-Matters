// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SelfReinforcementDAO
/// @notice DAO covenant for iterative feedback learning of agents
contract SelfReinforcementDAO {
    address public oversightCommittee;
    uint256 public feedbackCount;

    struct Feedback {
        uint256 id;
        address agent;
        string task;
        string outcome;
        string improvementNotes;
        uint256 timestamp;
    }

    mapping(uint256 => Feedback) public feedbacks;

    event FeedbackLogged(uint256 indexed id, address indexed agent, string task, string outcome, string improvementNotes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight logs agent feedback for reinforcement
    function logFeedback(address agent, string calldata task, string calldata outcome, string calldata improvementNotes) external onlyOversight {
        feedbackCount++;
        feedbacks[feedbackCount] = Feedback({
            id: feedbackCount,
            agent: agent,
            task: task,
            outcome: outcome,
            improvementNotes: improvementNotes,
            timestamp: block.timestamp
        });
        emit FeedbackLogged(feedbackCount, agent, task, outcome, improvementNotes);
    }

    /// @notice Citizens can view feedback records
    function viewFeedback(uint256 id) external view returns (Feedback memory) {
        return feedbacks[id];
    }
}
