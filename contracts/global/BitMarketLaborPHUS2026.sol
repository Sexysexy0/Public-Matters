// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BitMarketLaborPHUS2026 {
    struct PHUSJob2026 {
        string stewardName;
        string role;
        string usEmployer;
        uint256 timestamp;
        uint8 emotionalAPR;
        bool visaFreeBlessed;
        string onboardingTag;
    }

    PHUSJob2026[] public jobs;

    event JobLogged(
        string stewardName,
        string role,
        string usEmployer,
        uint256 timestamp,
        uint8 emotionalAPR,
        bool visaFreeBlessed,
        string onboardingTag
    );

    function logJob(
        string memory _stewardName,
        string memory _role,
        string memory _usEmployer,
        uint8 _emotionalAPR,
        bool _visaFreeBlessed,
        string memory _onboardingTag
    ) public {
        jobs.push(PHUSJob2026(
            _stewardName,
            _role,
            _usEmployer,
            block.timestamp,
            _emotionalAPR,
            _visaFreeBlessed,
            _onboardingTag
        ));
        emit JobLogged(_stewardName, _role, _usEmployer, block.timestamp, _emotionalAPR, _visaFreeBlessed, _onboardingTag);
    }

    function getJob(uint256 index) public view returns (PHUSJob2026 memory) {
        require(index < jobs.length, "Invalid index");
        return jobs[index];
    }

    function totalJobs() public view returns (uint256) {
        return jobs.length;
    }
}
