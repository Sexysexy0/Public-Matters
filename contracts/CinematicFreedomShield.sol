// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CinematicFreedomShield {
    struct Project {
        address actor;
        string title;
        string region;
        uint256 timestamp;
        bool safeguarded;
    }

    Project[] public projects;

    event ProjectLogged(address indexed actor, string title, string region);
    event ProjectSafeguarded(uint256 indexed id, address verifier);

    function logProject(string memory _title, string memory _region) public {
        projects.push(Project(msg.sender, _title, _region, block.timestamp, false));
        emit ProjectLogged(msg.sender, _title, _region);
    }

    function safeguardProject(uint256 _id) public {
        require(_id < projects.length, "Invalid ID");
        projects[_id].safeguarded = true;
        emit ProjectSafeguarded(_id, msg.sender);
    }

    function getProject(uint256 _id) public view returns (Project memory) {
        require(_id < projects.length, "Invalid ID");
        return projects[_id];
    }

    function totalProjects() public view returns (uint256) {
        return projects.length;
    }
}
