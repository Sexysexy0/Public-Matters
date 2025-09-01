// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract OneProjectOneContractor {
    struct Project {
        string name;
        string location;
        address assignedContractor;
        bool isLocked;
        uint256 timestamp;
    }

    mapping(bytes32 => Project) public projects;

    event ProjectAssigned(
        bytes32 indexed projectId,
        string name,
        string location,
        address assignedContractor,
        bool isLocked,
        uint256 timestamp
    );

    function assignProject(
        string memory name,
        string memory location,
        address contractor
    ) public {
        bytes32 projectId = keccak256(abi.encodePacked(name, location));
        require(projects[projectId].assignedContractor == address(0), "Project already assigned.");
        projects[projectId] = Project(
            name,
            location,
            contractor,
            true,
            block.timestamp
        );

        emit ProjectAssigned(
            projectId,
            name,
            location,
            contractor,
            true,
            block.timestamp
        );
    }

    function getProject(bytes32 projectId) public view returns (Project memory) {
        return projects[projectId];
    }
}
