// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BarangayJobHub {
    address public steward;
    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    constructor() { steward = msg.sender; }

    struct Job {
        uint256 id;
        string title;
        string employer;
        string location;
        uint256 payPerDayWei;
        uint256 openUntil; // unix timestamp
        bool active;
    }

    uint256 public jobCount;
    mapping(uint256 => Job) public jobs;

    event JobPosted(uint256 id, string title, string employer, string location, uint256 payPerDayWei, uint256 openUntil);
    event JobDeactivated(uint256 id);

    function postJob(
        string calldata title,
        string calldata employer,
        string calldata location,
        uint256 payPerDayWei,
        uint256 openUntil
    ) external onlySteward {
        jobCount++;
        jobs[jobCount] = Job(jobCount, title, employer, location, payPerDayWei, openUntil, true);
        emit JobPosted(jobCount, title, employer, location, payPerDayWei, openUntil);
    }

    function deactivateJob(uint256 id) external onlySteward {
        jobs[id].active = false;
        emit JobDeactivated(id);
    }
}
