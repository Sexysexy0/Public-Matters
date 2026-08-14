// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Transparency Mandate Registry
/// @notice Global ledger for governance projects, with special category for Human Preservation Covenants
contract TransparencyMandateRegistry {
    struct Project {
        bytes32 id;
        address contractAddress;
        string name;
        string description;
        string category;
    }

    mapping(bytes32 => Project) public projects;
    bytes32[] public projectIds;

    event ProjectFiled(
        bytes32 indexed id,
        address indexed contractAddress,
        string name,
        string description,
        string category
    );

    /// @notice File a new project into the registry
    function fileProject(
        bytes32 id,
        address contractAddress,
        string memory name,
        string memory description,
        string memory category
    ) public {
        require(projects[id].id == 0, "Project already exists");
        projects[id] = Project(id, contractAddress, name, description, category);
        projectIds.push(id);
        emit ProjectFiled(id, contractAddress, name, description, category);
    }

    /// @notice Special helper for Human Preservation Covenants
    function fileHumanPreservationCovenant(
        bytes32 id,
        address contractAddress,
        string memory name,
        string memory description
    ) public {
        fileProject(id, contractAddress, name, description, "HumanPreservation");
    }

    /// @notice Retrieve project details
    function getProject(bytes32 id) external view returns (Project memory) {
        return projects[id];
    }

    /// @notice List all project IDs
    function listProjects() external view returns (bytes32[] memory) {
        return projectIds;
    }
}
