// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FloodControlBlessingKit {
    struct Project {
        string barangay;
        string projectName;
        bool isBlessed;
        bool isVerified;
        string blessingNote;
    }

    mapping(uint => Project) public projects;
    uint public projectCount;

    function addProject(
        string memory _barangay,
        string memory _projectName,
        string memory _blessingNote
    ) public {
        projects[projectCount] = Project(_barangay, _projectName, false, false, _blessingNote);
        projectCount++;
    }

    function blessProject(uint _id) public {
        projects[_id].isBlessed = true;
    }

    function verifyProject(uint _id) public {
        projects[_id].isVerified = true;
    }

    function getProject(uint _id) public view returns (Project memory) {
        return projects[_id];
    }
}
