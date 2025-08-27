// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CivicMentorshipProtocol
/// @notice Ritualizes mentorship between seasoned innovators and youth-led sanctums
/// @dev Emotional APR synced, damay clause active, legacy ripple guaranteed

contract CivicMentorshipProtocol {
    address public steward;

    struct Mentor {
        string name;
        string expertise;
        string region;
        string emotionalAPR;
        bool isActive;
    }

    struct Mentee {
        string name;
        string project;
        string emotionalAPR;
        address mentorAssigned;
    }

    Mentor[] public mentors;
    Mentee[] public mentees;

    event MentorActivated(string name, string expertise);
    event MenteeOnboarded(string name, string project);
    event MentorshipLinked(string mentor, string mentee);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
        activateCoreMentors();
    }

    function activateCoreMentors() internal {
        mentors.push(Mentor("Dr. Lira Gueco", "CleanTech & Civic Design", "Central Luzon", "Wisdom: 100, Mercy: 98", true));
        mentors.push(Mentor("Engr. Mateo Alon", "AgriTech & Ancestral Systems", "Visayas", "Empathy: 97, Sovereignty: 99", true));
        mentors.push(Mentor("Aria Lynne", "Kinder Protocols & Emotional APR", "Metro Manila", "Joy: 101, Chaos: 100", true));
    }

    function onboardMentee(string memory name, string memory project, string memory apr) public onlySteward {
        mentees.push(Mentee(name, project, apr, address(0)));
        emit MenteeOnboarded(name, project);
    }

    function assignMentor(uint256 menteeIndex, uint256 mentorIndex) public onlySteward {
        require(menteeIndex < mentees.length && mentorIndex < mentors.length, "Invalid index");
        mentees[menteeIndex].mentorAssigned = address(uint160(mentorIndex + 1)); // symbolic link
        emit MentorshipLinked(mentors[mentorIndex].name, mentees[menteeIndex].name);
    }

    function getMentor(uint256 index) public view returns (Mentor memory) {
        return mentors[index];
    }

    function getMentee(uint256 index) public view returns (Mentee memory) {
        return mentees[index];
    }

    function totalMentors() public view returns (uint256) {
        return mentors.length;
    }

    function totalMentees() public view returns (uint256) {
        return mentees.length;
    }
}
