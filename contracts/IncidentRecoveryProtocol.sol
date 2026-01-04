pragma solidity ^0.8.20;

contract IncidentRecoveryProtocol {
    address public admin;

    struct Recovery {
        string system;       // e.g. server, app, network
        string step;         // e.g. restore backup, patch applied
        string status;       // e.g. ongoing, completed
        uint256 timestamp;
    }

    Recovery[] public recoveries;

    event RecoveryLogged(string system, string step, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logRecovery(string calldata system, string calldata step, string calldata status) external onlyAdmin {
        recoveries.push(Recovery(system, step, status, block.timestamp));
        emit RecoveryLogged(system, step, status, block.timestamp);
    }

    function totalRecoveries() external view returns (uint256) {
        return recoveries.length;
    }
}
