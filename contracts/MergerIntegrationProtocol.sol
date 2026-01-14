pragma solidity ^0.8.20;

contract MergerIntegrationProtocol {
    address public admin;

    struct Integration {
        string company;      // e.g. First Republic Bank
        string status;       // e.g. integrated, stabilized
        uint256 timestamp;
    }

    Integration[] public integrations;

    event IntegrationLogged(string company, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logIntegration(string calldata company, string calldata status) external onlyAdmin {
        integrations.push(Integration(company, status, block.timestamp));
        emit IntegrationLogged(company, status, block.timestamp);
    }

    function totalIntegrations() external view returns (uint256) {
        return integrations.length;
    }
}
