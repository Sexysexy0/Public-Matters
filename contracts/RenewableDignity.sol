// contracts/RenewableDignity.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RenewableDignity
 * @notice Protocol for communal dignity in renewable energy projects.
 */
contract RenewableDignity {
    address public admin;

    struct Project {
        string name;
        string type;       // "Solar", "Wind", "Hydro"
        uint256 capacity;  // MW
        string note;
        uint256 timestamp;
    }

    Project[] public projects;

    event ProjectLogged(string name, string type, uint256 capacity, string note, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logProject(string calldata name, string calldata type, uint256 capacity, string calldata note) external onlyAdmin {
        projects.push(Project(name, type, capacity, note, block.timestamp));
        emit ProjectLogged(name, type, capacity, note, block.timestamp);
    }

    function totalProjects() external view returns (uint256) {
        return projects.length;
    }

    function getProject(uint256 id) external view returns (Project memory) {
        require(id < projects.length, "Invalid id");
        return projects[id];
    }
}
