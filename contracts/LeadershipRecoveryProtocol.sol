pragma solidity ^0.8.20;

contract LeadershipRecoveryProtocol {
    address public admin;

    struct Recovery {
        string principle;    // e.g. strong leadership, return to fundamentals
        string action;       // e.g. fiscal discipline, resource strategy
        string hope;         // e.g. stabilize economy, rebuild trust
        uint256 timestamp;
    }

    Recovery[] public recoveries;

    event RecoveryLogged(string principle, string action, string hope, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRecovery(string calldata principle, string calldata action, string calldata hope) external onlyAdmin {
        recoveries.push(Recovery(principle, action, hope, block.timestamp));
        emit RecoveryLogged(principle, action, hope, block.timestamp);
    }

    function totalRecoveries() external view returns (uint256) {
        return recoveries.length;
    }
}
