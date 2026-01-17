pragma solidity ^0.8.20;

contract LoveForceProtocol {
    address public admin;

    struct Drive {
        string source;       // e.g. love, service, ambition
        string outcome;      // e.g. fulfillment, resilience
        uint256 timestamp;
    }

    Drive[] public drives;

    event DriveLogged(string source, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDrive(string calldata source, string calldata outcome) external onlyAdmin {
        drives.push(Drive(source, outcome, block.timestamp));
        emit DriveLogged(source, outcome, block.timestamp);
    }

    function totalDrives() external view returns (uint256) {
        return drives.length;
    }
}
