pragma solidity ^0.8.20;

contract FloodControlProtocol {
    address public admin;

    struct FloodProject {
        string location;     // e.g. Metro Manila, Batangas
        uint256 amount;      // e.g. 500000000
        string status;       // e.g. proposed, ongoing, suspicious
        uint256 timestamp;
    }

    FloodProject[] public floodProjects;

    event FloodProjectLogged(string location, uint256 amount, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logFloodProject(string calldata location, uint256 amount, string calldata status) external onlyAdmin {
        floodProjects.push(FloodProject(location, amount, status, block.timestamp));
        emit FloodProjectLogged(location, amount, status, block.timestamp);
    }

    function totalFloodProjects() external view returns (uint256) {
        return floodProjects.length;
    }
}
