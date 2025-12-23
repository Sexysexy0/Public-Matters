// contracts/OpenSourceCommons.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title OpenSourceCommons
 * @notice Logs communal open source projects and contributions.
 */
contract OpenSourceCommons {
    address public admin;

    struct Project {
        string name;        // "LibreOffice", "CommunityOS"
        string contributor;
        string status;      // "Active", "Archived"
        uint256 timestamp;
    }

    Project[] public projects;

    event ProjectLogged(string name, string contributor, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logProject(string calldata name, string calldata contributor, string calldata status) external onlyAdmin {
        projects.push(Project(name, contributor, status, block.timestamp));
        emit ProjectLogged(name, contributor, status, block.timestamp);
    }

    function totalProjects() external view returns (uint256) { return projects.length; }

    function getProject(uint256 id) external view returns (Project memory) {
        require(id < projects.length, "Invalid id");
        return projects[id];
    }
}
