// contracts/PublicWorksAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title PublicWorksAudit
 * @notice Communal audit of public works projects for transparency and accountability.
 */
contract PublicWorksAudit {
    address public admin;

    struct Project {
        string name;
        string status;   // "Ongoing", "Completed", "Delayed"
        string note;
        uint256 budget;
        uint256 timestamp;
    }

    Project[] public projects;

    event ProjectLogged(string name, string status, string note, uint256 budget, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logProject(string calldata name, string calldata status, string calldata note, uint256 budget) external onlyAdmin {
        projects.push(Project(name, status, note, budget, block.timestamp));
        emit ProjectLogged(name, status, note, budget, block.timestamp);
    }

    function totalProjects() external view returns (uint256) { return projects.length; }

    function getProject(uint256 id) external view returns (Project memory) {
        require(id < projects.length, "Invalid id");
        return projects[id];
    }
}
