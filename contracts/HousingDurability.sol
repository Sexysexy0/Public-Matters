// contracts/HousingDurability.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title HousingDurability
 * @notice Logs resilient housing projects and durability measures.
 */
contract HousingDurability {
    address public admin;

    struct Project {
        string name;        // "Northville Shelter", "EcoHousing"
        string location;
        string material;    // "Concrete", "Bamboo", "Hybrid"
        string status;      // "Planned", "Ongoing", "Completed"
        uint256 timestamp;
    }

    Project[] public projects;

    event ProjectLogged(string name, string location, string material, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logProject(string calldata name, string calldata location, string calldata material, string calldata status) external onlyAdmin {
        projects.push(Project(name, location, material, status, block.timestamp));
        emit ProjectLogged(name, location, material, status, block.timestamp);
    }

    function totalProjects() external view returns (uint256) { return projects.length; }

    function getProject(uint256 id) external view returns (Project memory) {
        require(id < projects.length, "Invalid id");
        return projects[id];
    }
}
