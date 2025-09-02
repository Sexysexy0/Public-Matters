// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BitMarketLabor {
    struct JobOffer {
        string employer;
        string stewardName;
        string role;
        string destinationCountry;
        uint256 timestamp;
        uint8 emotionalAPR; // 1–10 scale
        bool verifiedByTreaty;
    }

    JobOffer[] public offers;

    event JobDeployed(
        string employer,
        string stewardName,
        string role,
        string destinationCountry,
        uint256 timestamp,
        uint8 emotionalAPR,
        bool verifiedByTreaty
    );

    function deployJob(
        string memory _employer,
        string memory _stewardName,
        string memory _role,
        string memory _destinationCountry,
        uint8 _emotionalAPR,
        bool _verifiedByTreaty
    ) public {
        offers.push(JobOffer(
            _employer,
            _stewardName,
            _role,
            _destinationCountry,
            block.timestamp,
            _emotionalAPR,
            _verifiedByTreaty
        ));
        emit JobDeployed(_employer, _stewardName, _role, _destinationCountry, block.timestamp, _emotionalAPR, _verifiedByTreaty);
    }

    function getOffer(uint256 index) public view returns (JobOffer memory) {
        require(index < offers.length, "Invalid index");
        return offers[index];
    }

    function totalOffers() public view returns (uint256) {
        return offers.length;
    }
}
