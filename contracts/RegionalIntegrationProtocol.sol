pragma solidity ^0.8.20;

contract RegionalIntegrationProtocol {
    address public admin;

    struct Integration {
        string regionA;      // e.g. NCR
        string regionB;      // e.g. Bulacan
        string policy;       // e.g. unified wage scale
        uint256 timestamp;
    }

    Integration[] public integrations;

    event IntegrationLogged(string regionA, string regionB, string policy, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logIntegration(string calldata regionA, string calldata regionB, string calldata policy) external onlyAdmin {
        integrations.push(Integration(regionA, regionB, policy, block.timestamp));
        emit IntegrationLogged(regionA, regionB, policy, block.timestamp);
    }

    function totalIntegrations() external view returns (uint256) {
        return integrations.length;
    }
}
