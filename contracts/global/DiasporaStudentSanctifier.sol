// SPDX-License-Identifier: EducationSanctum
pragma solidity ^0.8.19;

contract DiasporaStudentSanctifier {
    address public steward;

    struct StudentRecord {
        string name;
        string university;
        string country;
        string fieldOfStudy;
        uint256 GPA;
        bool sanctified;
        string civicTag; // e.g. "STEM Diplomat", "Civic Contributor", "Diaspora Steward"
        uint256 timestamp;
    }

    StudentRecord[] public records;

    event StudentLogged(string name, string university, string country, string fieldOfStudy, uint256 GPA, string civicTag, uint256 timestamp);
    event StudentSanctified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logStudent(
        string memory name,
        string memory university,
        string memory country,
        string memory fieldOfStudy,
        uint256 GPA,
        string memory civicTag
    ) public {
        records.push(StudentRecord(name, university, country, fieldOfStudy, GPA, false, civicTag, block.timestamp));
        emit StudentLogged(name, university, country, fieldOfStudy, GPA, civicTag, block.timestamp);
    }

    function sanctifyStudent(uint256 index) public {
        require(index < records.length, "Invalid index");
        records[index].sanctified = true;
        emit StudentSanctified(index, msg.sender);
    }

    function getStudent(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256, bool, string memory, uint256
    ) {
        StudentRecord memory s = records[index];
        return (s.name, s.university, s.country, s.fieldOfStudy, s.GPA, s.sanctified, s.civicTag, s.timestamp);
    }

    function totalStudents() public view returns (uint256) {
        return records.length;
    }
}
