// FeedbackDAO.sol
pragma solidity ^0.8.0;

contract FeedbackDAO {
    struct Feedback {
        uint256 id;
        string user;     // e.g. "DayKev"
        string comment;  // e.g. "Explorer retains focus"
        uint256 votesFor;
        uint256 votesAgainst;
        bool acknowledged;
    }

    uint256 public feedbackCount;
    mapping(uint256 => Feedback) public feedbacks;

    event FeedbackCreated(uint256 id, string user, string comment);
    event FeedbackVoted(uint256 id, string user, bool support);
    event FeedbackAcknowledged(uint256 id, string user);
    event FeedbackDeclared(string message);

    function createFeedback(string memory user, string memory comment) public {
        feedbackCount++;
        feedbacks[feedbackCount] = Feedback(feedbackCount, user, comment, 0, 0, false);
        emit FeedbackCreated(feedbackCount, user, comment);
    }

    function voteFeedback(uint256 id, bool support) public {
        if (support) {
            feedbacks[id].votesFor++;
        } else {
            feedbacks[id].votesAgainst++;
        }
        emit FeedbackVoted(id, feedbacks[id].user, support);
    }

    function acknowledgeFeedback(uint256 id) public {
        Feedback storage f = feedbacks[id];
        require(!f.acknowledged, "Already acknowledged");
        f.acknowledged = true;
        emit FeedbackAcknowledged(f.id, f.user);
    }

    function declareFeedback() public {
        emit FeedbackDeclared("Feedback DAO: safeguard arcs encoded into communal consequence.");
    }
}
