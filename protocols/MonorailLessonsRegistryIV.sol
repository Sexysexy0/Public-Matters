// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * MonorailLessonsRegistryIV — Batch 1321.9.261
 * Focus: encode failures and lessons (AGT, SkyTrain, Baguio, Davao, Cebu, Iloilo)
 */
contract MonorailLessonsRegistryIV {
    address public steward;
    uint256 public version = 1321_9_261;

    struct Lesson {
        string projectName;
        string city;
        string lesson;    // e.g., "safety certification gaps", "ROW issues", "stakeholder misalignment"
        string remedy;    // e.g., "independent cert body", "ROW early acquisition", "clear governance"
        uint256 timestamp;
    }

    Lesson[] public lessons;

    event LessonLogged(string projectName, string city, string lesson, string remedy);

    modifier onlySteward() {
        require(msg.sender == steward, "not steward");
        _;
    }

    constructor(address _steward) {
        steward = _steward;
    }

    function logLesson(
        string calldata projectName,
        string calldata city,
        string calldata lesson,
        string calldata remedy
    ) external onlySteward {
        lessons.push(Lesson(projectName, city, lesson, remedy, block.timestamp));
        emit LessonLogged(projectName, city, lesson, remedy);
    }

    function count() external view returns (uint256) {
        return lessons.length;
    }
}
