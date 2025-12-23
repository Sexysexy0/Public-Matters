// contracts/NetNeutralityAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title NetNeutralityAudit
 * @notice Tracks communal audits of net neutrality compliance.
 */
contract NetNeutralityAudit {
    address public admin;

    struct Audit {
        string isp;
        string verdict;     // "Compliant", "Violation"
        string note;
        uint256 timestamp;
    }

    Audit[] public audits;

    event AuditLogged(string isp, string verdict, string note, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logAudit(string calldata isp, string calldata verdict, string calldata note) external onlyAdmin {
        audits.push(Audit(isp, verdict, note, block.timestamp));
        emit AuditLogged(isp, verdict, note, block.timestamp);
    }

    function totalAudits() external view returns (uint256) { return audits.length; }

    function getAudit(uint256 id) external view returns (Audit memory) {
        require(id < audits.length, "Invalid id");
        return audits[id];
    }
}
