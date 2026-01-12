pragma solidity ^0.8.20;

contract EconomicRecoveryProtocol {
    address public admin;

    struct Recovery {
        string sector;       // e.g. food, energy, housing
        string status;       // e.g. initiated, ongoing, completed
        uint256 timestamp;
    }

    Recovery[] public recoveries;

    event RecoveryLogged(string sector, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRecovery(string calldata sector, string calldata status) external onlyAdmin {
        recoveries.push(Recovery(sector, status, block.timestamp));
        emit RecoveryLogged(sector, status, block.timestamp);
    }

    function totalRecoveries() external view returns (uint256) {
        return recoveries.length;
    }
}
