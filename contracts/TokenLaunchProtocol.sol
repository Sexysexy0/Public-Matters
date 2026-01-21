pragma solidity ^0.8.20;

contract TokenLaunchProtocol {
    address public admin;

    struct Launch {
        string project;      // e.g. new token, retail protection
        string focus;        // e.g. survival, adoption, compliance
        uint256 timestamp;
    }

    Launch[] public launches;

    event LaunchLogged(string project, string focus, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logLaunch(string calldata project, string calldata focus) external onlyAdmin {
        launches.push(Launch(project, focus, block.timestamp));
        emit LaunchLogged(project, focus, block.timestamp);
    }

    function totalLaunches() external view returns (uint256) {
        return launches.length;
    }
}
