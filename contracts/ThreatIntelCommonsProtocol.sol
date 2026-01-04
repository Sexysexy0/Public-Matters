pragma solidity ^0.8.20;

contract ThreatIntelCommonsProtocol {
    address public admin;

    struct Intel {
        string source;       // e.g. feed, report, community
        string type;         // e.g. malware, phishing, zero-day
        uint256 timestamp;
    }

    Intel[] public intelLogs;

    event IntelLogged(string source, string type, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logIntel(string calldata source, string calldata type) external onlyAdmin {
        intelLogs.push(Intel(source, type, block.timestamp));
        emit IntelLogged(source, type, block.timestamp);
    }

    function totalIntel() external view returns (uint256) {
        return intelLogs.length;
    }
}
