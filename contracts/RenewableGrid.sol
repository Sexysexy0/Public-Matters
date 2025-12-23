// contracts/RenewableGrid.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RenewableGrid
 * @notice Logs renewable energy projects and communal grid resilience.
 */
contract RenewableGrid {
    address public admin;

    struct Project {
        string name;        // "SolarFarm", "WindPark"
        string location;
        string type;        // "Solar", "Wind", "Hydro"
        string status;      // "Planned", "Operational"
        uint256 capacity;   // in MW
        uint256 timestamp;
    }

    Project[] public projects;

    event ProjectLogged(string name, string location, string type, string status, uint256 capacity, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logProject(string calldata name, string calldata location, string calldata type, string calldata status, uint256 capacity) external onlyAdmin {
        projects.push(Project(name, location, type, status, capacity, block.timestamp));
        emit ProjectLogged(name, location, type, status, capacity, block.timestamp);
    }

    function totalProjects() external view returns (uint256) { return projects.length; }

    function getProject(uint256 id) external view returns (Project memory) {
        require(id < projects.length, "Invalid id");
        return projects[id];
    }
}
