pragma solidity ^0.8.20;

contract MeetingSecurityProtocol {
    address public admin;

    struct Meeting {
        string platform;     // e.g. Zoom, Teams, Meet
        string issue;        // e.g. stolen URL, leaked password
        string status;       // e.g. secure, compromised, patched
        uint256 timestamp;
    }

    Meeting[] public meetings;

    event MeetingLogged(string platform, string issue, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logMeeting(string calldata platform, string calldata issue, string calldata status) external onlyAdmin {
        meetings.push(Meeting(platform, issue, status, block.timestamp));
        emit MeetingLogged(platform, issue, status, block.timestamp);
    }

    function totalMeetings() external view returns (uint256) {
        return meetings.length;
    }
}
