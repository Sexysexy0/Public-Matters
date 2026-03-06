// ParticipatoryOversightProtocol.sol
pragma solidity ^0.8.0;

contract ParticipatoryOversightProtocol {
    struct Feedback {
        uint256 id;
        string citizen;   // e.g. "Community Member"
        string reform;    // e.g. "Anti-Political Dynasty Bill"
        string comment;   // e.g. "Needs stronger enforcement"
        uint256 timestamp;
    }

    uint256 public feedbackCount;
    mapping(uint256 => Feedback) public feedbacks;

    event FeedbackLogged(uint256 id, string citizen, string reform, string comment);

    function logFeedback(string memory citizen, string memory reform, string memory comment) public {
        feedbackCount++;
        feedbacks[feedbackCount] = Feedback(feedbackCount, citizen, reform, comment, block.timestamp);
        emit FeedbackLogged(feedbackCount, citizen, reform, comment);
    }
}
