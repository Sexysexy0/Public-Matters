pragma solidity ^0.8.20;

contract TeslaRecoveryProtocol {
    address public admin;

    struct Recovery {
        string region;       // e.g. Europe
        string challenge;    // e.g. sales decline, competition
        string strategy;     // e.g. local production, pricing adjustment
        uint256 timestamp;
    }

    Recovery[] public recoveries;

    event RecoveryLogged(string region, string challenge, string strategy, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRecovery(string calldata region, string calldata challenge, string calldata strategy) external onlyAdmin {
        recoveries.push(Recovery(region, challenge, strategy, block.timestamp));
        emit RecoveryLogged(region, challenge, strategy, block.timestamp);
    }

    function totalRecoveries() external view returns (uint256) {
        return recoveries.length;
    }
}
