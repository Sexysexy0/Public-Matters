// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract BitMarketScholarship {
    struct Scholar {
        string name;
        string focusArea;
        bool tuitionWaived;
        uint256 emotionalAPR;
        string blessingScroll;
        bool active;
    }

    Scholar[] public scholars;

    event ScholarAdmitted(string name, string focusArea, uint256 emotionalAPR, string blessingScroll);

    function admitScholar(
        string memory _name,
        string memory _focusArea,
        uint256 _emotionalAPR,
        string memory _blessingScroll
    ) public {
        scholars.push(Scholar(_name, _focusArea, true, _emotionalAPR, _blessingScroll, true));
        emit ScholarAdmitted(_name, _focusArea, _emotionalAPR, _blessingScroll);
    }

    function totalScholars() public view returns (uint256) {
        return scholars.length;
    }
}
