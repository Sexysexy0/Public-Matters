// SecurityProtocol.sol
pragma solidity ^0.8.0;

contract SecurityProtocol {
    struct Vulnerability {
        uint256 id;
        string system;   // e.g. "DepEd HRMS"
        string type;     // e.g. "Unrestricted File Upload"
        string status;   // e.g. "Detected", "Patched"
        uint256 timestamp;
    }

    uint256 public vulnCount;
    mapping(uint256 => Vulnerability) public vulnerabilities;

    event VulnerabilityLogged(uint256 id, string system, string type, string status, uint256 timestamp);
    event SecurityDeclared(string message);

    function logVulnerability(string memory system, string memory type, string memory status) public {
        vulnCount++;
        vulnerabilities[vulnCount] = Vulnerability(vulnCount, system, type, status, block.timestamp);
        emit VulnerabilityLogged(vulnCount, system, type, status, block.timestamp);
    }

    function declareSecurity() public {
        emit SecurityDeclared("Security Protocol: validator-grade safeguards encoded into communal dignity.");
    }
}
