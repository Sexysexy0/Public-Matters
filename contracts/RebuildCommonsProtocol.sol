pragma solidity ^0.8.20;

contract RebuildCommonsProtocol {
    address public admin;

    struct Project {
        string name;         // e.g. housing, health insurance, transport
        string status;       // e.g. initiated, ongoing, completed
        uint256 timestamp;
    }

    Project[] public projects;

    event ProjectLogged(string name, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logProject(string calldata name, string calldata status) external onlyAdmin {
        projects.push(Project(name, status, block.timestamp));
        emit ProjectLogged(name, status, block.timestamp);
    }

    function totalProjects() external view returns (uint256) {
        return projects.length;
    }
}
