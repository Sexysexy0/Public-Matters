// ResourceAccountabilityProtocol.sol
pragma solidity ^0.8.0;

contract ResourceAccountabilityProtocol {
    struct Audit {
        uint256 id;
        string resource;   // e.g. "Hospital Budget"
        string safeguard;  // e.g. "Ensure fair and transparent use of health funds"
        uint256 timestamp;
    }

    uint256 public auditCount;
    mapping(uint256 => Audit) public audits;

    event AuditLogged(uint256 id, string resource, string safeguard);

    function logAudit(string memory resource, string memory safeguard) public {
        auditCount++;
        audits[auditCount] = Audit(auditCount, resource, safeguard, block.timestamp);
        emit AuditLogged(auditCount, resource, safeguard);
    }
}
