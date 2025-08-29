// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BarangayJobHubV52 {
    address public steward;
    uint256 public jobCount;
    uint256 public trainingCount;

    constructor() { steward = msg.sender; }
    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }

    struct Job {
        uint256 id;
        string title;
        string employer;
        string location;
        uint256 payPerDayWei;
        bool active;
        bool nearHome; // true if barangay-level task
        bool parentFriendly;
    }

    struct Training {
        uint256 id;
        string title;
        string skillCategory;
        uint256 durationHours;
        bool withChildcare;
        bool hobbyToIncome;
    }

    mapping(uint256 => Job) public jobs;
    mapping(uint256 => Training) public trainings;

    event JobPosted(uint256 id, string title, bool nearHome, bool parentFriendly);
    event TrainingPosted(uint256 id, string title, bool withChildcare, bool hobbyToIncome);

    function postJob(
        string calldata title,
        string calldata employer,
        string calldata location,
        uint256 payPerDayWei,
        bool nearHome,
        bool parentFriendly
    ) external onlySteward {
        jobCount++;
        jobs[jobCount] = Job(jobCount, title, employer, location, payPerDayWei, true, nearHome, parentFriendly);
        emit JobPosted(jobCount, title, nearHome, parentFriendly);
    }

    function postTraining(
        string calldata title,
        string calldata skillCategory,
        uint256 durationHours,
        bool withChildcare,
        bool hobbyToIncome
    ) external onlySteward {
        trainingCount++;
        trainings[trainingCount] = Training(trainingCount, title, skillCategory, durationHours, withChildcare, hobbyToIncome);
        emit TrainingPosted(trainingCount, title, withChildcare, hobbyToIncome);
    }
}
