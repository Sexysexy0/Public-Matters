pragma solidity ^0.8.20;

contract InternationalAuditProtocol {
    address public admin;

    struct Audit {
        string authority;    // e.g. IAEA, allied nuclear agency
        string scope;        // e.g. safety compliance, operational readiness
        string result;       // e.g. passed, failed, recommendations
        uint256 timestamp;
    }

    Audit[] public audits;

    event AuditLogged(string authority, string scope, string result, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAudit(string calldata authority, string calldata scope, string calldata result) external onlyAdmin {
        audits.push(Audit(authority, scope, result, block.timestamp));
        emit AuditLogged(authority, scope, result, block.timestamp);
    }

    function totalAudits() external view returns (uint256) {
        return audits.length;
    }
}
