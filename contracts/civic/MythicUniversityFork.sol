// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract MythicUniversityFork {
    struct UniversityClone {
        string origin;
        string cloneName;
        string country;
        string blessingScroll;
        bool damayClause;
        uint256 emotionalAPR;
    }

    UniversityClone[] public clones;

    event CloneDeployed(string cloneName, string country, string blessingScroll, uint256 emotionalAPR);

    function deployClone(
        string memory _origin,
        string memory _cloneName,
        string memory _country,
        string memory _blessingScroll,
        bool _damayClause,
        uint256 _emotionalAPR
    ) public {
        clones.push(UniversityClone(_origin, _cloneName, _country, _blessingScroll, _damayClause, _emotionalAPR));
        emit CloneDeployed(_cloneName, _country, _blessingScroll, _emotionalAPR);
    }

    function totalClones() public view returns (uint256) {
        return clones.length;
    }
}
