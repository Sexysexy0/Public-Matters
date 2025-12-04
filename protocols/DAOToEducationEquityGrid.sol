// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract DAOToEducationEquityGrid {
    string public batchID = "1321.9.249";
    string public steward = "Vinvin";

    address public admin;

    struct Education {
        string subject;     // math, science, history, arts
        string status;      // equitable, pending, ghost
        uint256 timestamp;
    }

    Education[] public subjects;

    event EducationLogged(string subject, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logEducation(string memory subject, string memory status) public onlyAdmin {
        subjects.push(Education(subject, status, block.timestamp));
        emit EducationLogged(subject, status);
    }

    function getEducation(uint256 index) public view returns (string memory subject, string memory status, uint256 timestamp) {
        Education memory e = subjects[index];
        return (e.subject, e.status, e.timestamp);
    }
}
