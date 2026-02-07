// ComfortDAO.sol
pragma solidity ^0.8.0;

contract ComfortDAO {
    struct Feedback {
        uint256 id;
        string aspect;   // e.g. "Seating", "Temperature", "Noise"
        string rating;   // e.g. "Excellent", "Average"
        uint256 votesFor;
        uint256 votesAgainst;
        bool published;
    }

    uint256 public feedbackCount;
    mapping(uint256 => Feedback) public feedbacks;

    event FeedbackCreated(uint256 id, string aspect, string rating);
    event FeedbackVoted(uint256 id, string aspect, bool support);
    event FeedbackPublished(uint256 id, string aspect);
    event ComfortDeclared(string message);

    function createFeedback(string memory aspect, string memory rating) public {
        feedbackCount++;
        feedbacks[feedbackCount] = Feedback(feedbackCount, aspect, rating, 0, 0, false);
        emit FeedbackCreated(feedbackCount, aspect, rating);
    }

    function voteFeedback(uint256 id, bool support) public {
        if (support) {
            feedbacks[id].votesFor++;
        } else {
            feedbacks[id].votesAgainst++;
        }
        emit FeedbackVoted(id, feedbacks[id].aspect, support);
    }

    function publishFeedback(uint256 id) public {
        Feedback storage f = feedbacks[id];
        require(!f.published, "Already published");
        require(f.votesFor > f.votesAgainst, "Not enough support");
        f.published = true;
        emit FeedbackPublished(f.id, f.aspect);
    }

    function declareComfort() public {
        emit ComfortDeclared("Comfort DAO: safeguard arcs encoded into communal consequence.");
    }
}
