// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract EmotionalAPRWorkshop {
    address public steward;

    struct Participant {
        string name;
        string agency;
        uint8 trustScore;
        uint8 mercyScore;
        uint8 clarityScore;
        bool certified;
    }

    Participant[] public participants;

    event APRCertified(string name, string agency, uint8 trust, uint8 mercy, uint8 clarity);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function enrollParticipant(
        string memory name,
        string memory agency,
        uint8 trustScore,
        uint8 mercyScore,
        uint8 clarityScore
    ) public onlySteward {
        bool certified = (trustScore + mercyScore + clarityScore) >= 210;

        Participant memory newParticipant = Participant({
            name: name,
            agency: agency,
            trustScore: trustScore,
            mercyScore: mercyScore,
            clarityScore: clarityScore,
            certified: certified
        });

        participants.push(newParticipant);
        emit APRCertified(name, agency, trustScore, mercyScore, clarityScore);
    }

    function getParticipant(uint256 index) public view returns (Participant memory) {
        require(index < participants.length, "Invalid index");
        return participants[index];
    }

    function totalParticipants() public view returns (uint256) {
        return participants.length;
    }
}
