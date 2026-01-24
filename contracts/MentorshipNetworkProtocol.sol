pragma solidity ^0.8.20;

contract MentorshipNetworkProtocol {
    address public admin;

    struct Mentorship {
        string mentor;       // e.g. professional, entrepreneur
        string mentee;       // e.g. student, worker
        string focus;        // e.g. career roadmap, skill guidance
        uint256 timestamp;
    }

    Mentorship[] public mentorships;

    event MentorshipLogged(string mentor, string mentee, string focus, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logMentorship(string calldata mentor, string calldata mentee, string calldata focus) external onlyAdmin {
        mentorships.push(Mentorship(mentor, mentee, focus, block.timestamp));
        emit MentorshipLogged(mentor, mentee, focus, block.timestamp);
    }

    function totalMentorships() external view returns (uint256) {
        return mentorships.length;
    }
}
