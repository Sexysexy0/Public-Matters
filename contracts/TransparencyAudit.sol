// contracts/TransparencyAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TransparencyAudit {
    struct Audit {
        string project;
        string report;
        uint256 timestamp;
        address auditor;
    }

    Audit[] public audits;
    event AuditLogged(string project, string report, address auditor, uint256 timestamp);

    function logAudit(string calldata project, string calldata report) external {
        audits.push(Audit(project, report, block.timestamp, msg.sender));
        emit AuditLogged(project, report, msg.sender, block.timestamp);
    }

    function totalAudits() external view returns (uint256) {
        return audits.length;
    }
}
