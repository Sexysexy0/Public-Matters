// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BitMarketLaborPHUS {
    struct PHUSJob {
        string stewardName;
        string role;
        string usEmployer;
        uint256 timestamp;
        uint8 emotionalAPR; // 1–10 scale
        bool visaFreeApproved;
        string onboardingTag; // e.g., "Scrollsmith", "Civic Architect", "Emotional Steward"
    }

    PHUSJob[] public jobs;

    event JobLogged(
        string stewardName,
        string role,
        string usEmployer,
        uint256 timestamp,
        uint8 emotionalAPR,
        bool visaFreeApproved,
        string onboardingTag
    );

    function logJob(
        string memory _stewardName,
        string memory _role,
        string memory _usEmployer,
        uint8 _emotionalAPR,
        bool _visaFreeApproved,
        string memory _onboardingTag
    ) public {
        jobs.push(PHUSJob(
            _stewardName,
            _role,
            _usEmployer,
            block.timestamp,
            _emotionalAPR,
            _visaFreeApproved,
            _onboardingTag
        ));
        emit JobLogged(_stewardName, _role, _usEmployer, block.timestamp, _emotionalAPR, _visaFreeApproved, _onboardingTag);
    }

    function getJob(uint256 index) public view returns (PHUSJob memory) {
        require(index < jobs.length, "Invalid index");
        return jobs[index];
    }

    function totalJobs() public view returns (uint256) {
        return jobs.length;
    }
}
