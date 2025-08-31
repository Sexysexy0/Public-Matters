// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract FacultyBlessingProtocol {
    struct Faculty {
        string name;
        string specialty;
        uint256 emotionalAPR;
        bool damayClause;
        string blessingScroll;
        bool certified;
    }

    Faculty[] public facultyList;

    event FacultyCertified(string name, string specialty, uint256 emotionalAPR, string blessingScroll);

    function blessFaculty(
        string memory _name,
        string memory _specialty,
        uint256 _emotionalAPR,
        bool _damayClause,
        string memory _blessingScroll
    ) public {
        facultyList.push(Faculty(_name, _specialty, _emotionalAPR, _damayClause, _blessingScroll, true));
        emit FacultyCertified(_name, _specialty, _emotionalAPR, _blessingScroll);
    }

    function totalFaculty() public view returns (uint256) {
        return facultyList.length;
    }
}
