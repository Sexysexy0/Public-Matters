pragma solidity ^0.8.20;

contract TransparencyAuditProtocol {
    address public admin;

    struct Audit {
        string ordinance;    // e.g. Ordinance 9151
        string process;      // e.g. public consultation, sudden adjustment
        string clarity;      // e.g. transparent, lacking
        uint256 timestamp;
    }

    Audit[] public audits;

    event AuditLogged(string ordinance, string process, string clarity, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAudit(string calldata ordinance, string calldata process, string calldata clarity) external onlyAdmin {
        audits.push(Audit(ordinance, process, clarity, block.timestamp));
        emit AuditLogged(ordinance, process, clarity, block.timestamp);
    }

    function totalAudits() external view returns (uint256) {
        return audits.length;
    }
}
