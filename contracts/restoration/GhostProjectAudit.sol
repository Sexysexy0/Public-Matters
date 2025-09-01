// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract GhostProjectAudit {
    struct Project {
        string name;
        string location;
        uint256 allocatedBudget;
        bool physicallyVerified;
        string status;
        address responsibleOfficial;
    }

    mapping(bytes32 => Project) public ghostProjects;

    event GhostProjectLogged(
        bytes32 indexed projectId,
        string name,
        string location,
        uint256 allocatedBudget,
        bool physicallyVerified,
        string status,
        address responsibleOfficial
    );

    function logGhostProject(
        string memory name,
        string memory location,
        uint256 allocatedBudget,
        bool physicallyVerified,
        string memory status,
        address responsibleOfficial
    ) public {
        bytes32 projectId = keccak256(abi.encodePacked(name, location, block.timestamp));
        ghostProjects[projectId] = Project(
            name,
            location,
            allocatedBudget,
            physicallyVerified,
            status,
            responsibleOfficial
        );

        emit GhostProjectLogged(
            projectId,
            name,
            location,
            allocatedBudget,
            physicallyVerified,
            status,
            responsibleOfficial
        );
    }

    function getGhostProject(bytes32 projectId) public view returns (Project memory) {
        return ghostProjects[projectId];
    }
}
