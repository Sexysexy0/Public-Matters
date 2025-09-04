// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./ScrollchainSync.sol"; // Optional: connect to scrollchain ledger

contract BitMarketLaborPHUS2026 {
    address public steward;
    ScrollchainSync public sync;

    struct PHUSJob2026 {
        string stewardName;
        string role;
        string usEmployer;
        uint256 timestamp;
        uint8 emotionalAPR;
        bool visaFreeBlessed;
        string onboardingTag;
        string blessingNote;
    }

    PHUSJob2026[] public jobs;

    event JobLogged(
        string stewardName,
        string role,
        string usEmployer,
        uint256 timestamp,
        uint8 emotionalAPR,
        bool visaFreeBlessed,
        string onboardingTag,
        string blessingNote
    );

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor(address _syncAddress) {
        steward = msg.sender;
        sync = ScrollchainSync(_syncAddress);
    }

    function logJob(
        string memory _stewardName,
        string memory _role,
        string memory _usEmployer,
        uint8 _emotionalAPR,
        bool _visaFreeBlessed,
        string memory _onboardingTag,
        string memory _blessingNote
    ) public onlySteward {
        require(_emotionalAPR >= 50, "Emotional APR too low for treaty-grade blessing");

        jobs.push(PHUSJob2026(
            _stewardName,
            _role,
            _usEmployer,
            block.timestamp,
            _emotionalAPR,
            _visaFreeBlessed,
            _onboardingTag,
            _blessingNote
        ));

        emit JobLogged(_stewardName, _role, _usEmployer, block.timestamp, _emotionalAPR, _visaFreeBlessed, _onboardingTag, _blessingNote);

        // Sync to scrollchain ledger
        sync.syncScroll(
            "PHUSJobBlessing",
            string(abi.encodePacked(
                "Blessed job for steward: ", _stewardName,
                " | Role: ", _role,
                " | Employer: ", _usEmployer,
                " | APR: ", uint2str(_emotionalAPR),
                " | Tag: ", _onboardingTag,
                " | Note: ", _blessingNote
            ))
        );
    }

    function getJob(uint256 index) public view returns (PHUSJob2026 memory) {
        require(index < jobs.length, "Invalid index");
        return jobs[index];
    }

    function totalJobs() public view returns (uint256) {
        return jobs.length;
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        j = _i;
        while (j != 0) {
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        return string(bstr);
    }
}
