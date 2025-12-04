// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract TreatyToClassroomSystemsAuditLedger {
    string public batchID = "1321.9.249";
    string public steward = "Vinvin";

    address public admin;

    struct Classroom {
        string system;     // grading, attendance, curriculum delivery
        string status;     // audited, pending, ghost
        uint256 timestamp;
    }

    Classroom[] public classrooms;

    event ClassroomLogged(string system, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logClassroom(string memory system, string memory status) public onlyAdmin {
        classrooms.push(Classroom(system, status, block.timestamp));
        emit ClassroomLogged(system, status);
    }

    function getClassroom(uint256 index) public view returns (string memory system, string memory status, uint256 timestamp) {
        Classroom memory c = classrooms[index];
        return (c.system, c.status, c.timestamp);
    }
}
