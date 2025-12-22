// contracts/RelocationMarket.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RelocationMarket
 * @notice Ledger for public market building projects to relocate displaced vendors.
 */
contract RelocationMarket {
    address public admin;

    struct Project {
        string name;                 // market name
        string location;             // city/barangay
        uint256 vendorsRelocated;    // number of vendors
        string displacementReason;   // "Modernization", "Demolition", etc.
        string status;               // "Planned", "Ongoing", "Completed"
        uint256 timestamp;           // last update
    }

    Project[] public projects;

    event ProjectLogged(
        string name,
        string location,
        uint256 vendorsRelocated,
        string displacementReason,
        string status,
        uint256 timestamp
    );

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logProject(
        string calldata name,
        string calldata location,
        uint256 vendorsRelocated,
        string calldata displacementReason,
        string calldata status
    ) external onlyAdmin {
        projects.push(Project(
            name,
            location,
            vendorsRelocated,
            displacementReason,
            status,
            block.timestamp
        ));
        emit ProjectLogged(name, location, vendorsRelocated, displacementReason, status, block.timestamp);
    }

    function updateStatus(uint256 id, string calldata status, uint256 vendorsRelocated) external onlyAdmin {
        require(id < projects.length, "Invalid id");
        projects[id].status = status;
        projects[id].vendorsRelocated = vendorsRelocated;
        projects[id].timestamp = block.timestamp;
        emit ProjectLogged(
            projects[id].name,
            projects[id].location,
            projects[id].vendorsRelocated,
            projects[id].displacementReason,
            projects[id].status,
            projects[id].timestamp
        );
    }

    function totalProjects() external view returns (uint256) {
        return projects.length;
    }

    function getProject(uint256 id) external view returns (Project memory) {
        require(id < projects.length, "Invalid id");
        return projects[id];
    }
}
