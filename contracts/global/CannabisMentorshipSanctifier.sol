// SPDX-License-Identifier: MentorshipSanctum
pragma solidity ^0.8.19;

contract CannabisMentorshipSanctifier {
    struct MentorshipProgram {
        string mentorID;
        string menteeID;
        string focusArea;
        bool completed;
        string stewardNote;
    }

    mapping(string => MentorshipProgram) public mentorshipLedger;

    event MentorshipTagged(string mentorID, string focusArea);
    event MentorshipSanctified(string menteeID);

    function tagMentorship(string memory mentorID, string memory menteeID, string memory focusArea, string memory stewardNote) public {
        mentorshipLedger[menteeID] = MentorshipProgram(mentorID, menteeID, focusArea, false, stewardNote);
        emit MentorshipTagged(mentorID, focusArea);
    }

    function sanctifyMentorship(string memory menteeID) public {
        require(bytes(mentorshipLedger[menteeID].focusArea).length > 0, "Mentorship not tagged");
        mentorshipLedger[menteeID].completed = true;
        emit MentorshipSanctified(menteeID);
    }

    function getMentorshipStatus(string memory menteeID) public view returns (MentorshipProgram memory) {
        return mentorshipLedger[menteeID];
    }
}
