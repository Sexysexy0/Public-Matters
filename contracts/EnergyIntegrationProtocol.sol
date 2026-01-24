pragma solidity ^0.8.20;

contract EnergyIntegrationProtocol {
    address public admin;

    struct Integration {
        string grid;         // e.g. Luzon Grid, National Grid
        string method;       // e.g. baseload supply, hybrid with renewables
        string benefit;      // e.g. stability, reduced carbon emissions
        uint256 timestamp;
    }

    Integration[] public integrations;

    event IntegrationLogged(string grid, string method, string benefit, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logIntegration(string calldata grid, string calldata method, string calldata benefit) external onlyAdmin {
        integrations.push(Integration(grid, method, benefit, block.timestamp));
        emit IntegrationLogged(grid, method, benefit, block.timestamp);
    }

    function totalIntegrations() external view returns (uint256) {
        return integrations.length;
    }
}
