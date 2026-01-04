pragma solidity ^0.8.20;

contract CyberSecurityCommonsProtocol {
    address public admin;

    struct Threat {
        string vector;       // e.g. phishing, malware, ransomware
        string status;       // e.g. detected, mitigated, ongoing
        uint256 timestamp;
    }

    Threat[] public threats;

    event ThreatLogged(string vector, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logThreat(string calldata vector, string calldata status) external onlyAdmin {
        threats.push(Threat(vector, status, block.timestamp));
        emit ThreatLogged(vector, status, block.timestamp);
    }

    function totalThreats() external view returns (uint256) {
        return threats.length;
    }
}
