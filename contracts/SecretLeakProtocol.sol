pragma solidity ^0.8.20;

contract SecretLeakProtocol {
    address public admin;

    struct Leak {
        string app;          // e.g. Android AI app name
        string secretType;   // e.g. Google Cloud API Key
        string riskLevel;    // e.g. low, medium, high
        uint256 timestamp;
    }

    Leak[] public leaks;

    event LeakLogged(string app, string secretType, string riskLevel, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logLeak(string calldata app, string calldata secretType, string calldata riskLevel) external onlyAdmin {
        leaks.push(Leak(app, secretType, riskLevel, block.timestamp));
        emit LeakLogged(app, secretType, riskLevel, block.timestamp);
    }

    function totalLeaks() external view returns (uint256) {
        return leaks.length;
    }
}
