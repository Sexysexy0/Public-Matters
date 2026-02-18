// UtilityProtocol.sol
pragma solidity ^0.8.0;

contract UtilityProtocol {
    struct Service {
        uint256 id;
        string provider;   // e.g. "PNM"
        string domain;     // e.g. "Electricity"
        uint256 customers; // e.g. 800000
        string status;     // e.g. "Public", "Private"
        uint256 timestamp;
    }

    uint256 public serviceCount;
    mapping(uint256 => Service) public services;

    event ServiceLogged(uint256 id, string provider, string domain, uint256 customers, string status, uint256 timestamp);
    event UtilityDeclared(string message);

    function logService(string memory provider, string memory domain, uint256 customers, string memory status) public {
        serviceCount++;
        services[serviceCount] = Service(serviceCount, provider, domain, customers, status, block.timestamp);
        emit ServiceLogged(serviceCount, provider, domain, customers, status, block.timestamp);
    }

    function declareUtility() public {
        emit UtilityDeclared("Utility Protocol: validator-grade safeguards encoded into communal dignity.");
    }
}
