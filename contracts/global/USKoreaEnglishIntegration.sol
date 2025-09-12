// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract USKoreaEnglishIntegration {
    enum ProgramType { SchoolEmbedded, CommunityCenter, OnlineExchange }
    enum TutorStatus { Pending, Active, Completed }

    struct Tutor {
        uint256 id;
        string name;
        string originState;
        ProgramType programType;
        string assignedRegion;
        TutorStatus status;
        uint256 startDate;
        uint256 endDate;
    }

    mapping(uint256 => Tutor) public tutorRegistry;
    uint256 public tutorCount;

    event TutorDeployed(uint256 id, string region, ProgramType programType);
    event TutorCompleted(uint256 id);

    function deployTutor(
        string memory name,
        string memory originState,
        ProgramType programType,
        string memory assignedRegion,
        uint256 startDate,
        uint256 endDate
    ) public {
        tutorRegistry[tutorCount] = Tutor(
            tutorCount,
            name,
            originState,
            programType,
            assignedRegion,
            TutorStatus.Active,
            startDate,
            endDate
        );
        emit TutorDeployed(tutorCount, assignedRegion, programType);
        tutorCount++;
    }

    function completeTutor(uint256 id) public {
        require(id < tutorCount, "Invalid tutor ID");
        tutorRegistry[id].status = TutorStatus.Completed;
        emit TutorCompleted(id);
    }

    function getTutor(uint256 id) public view returns (Tutor memory) {
        return tutorRegistry[id];
    }
}
