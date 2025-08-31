// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.19;

contract NonPartisanAuditProtocol {
    struct AuditEntry {
        string agency;
        string subject;
        string findings;
        string emotionalAPR;
        bool politicallyNeutral;
        uint256 timestamp;
        address auditor;
    }

    AuditEntry[] public entries;

    event AuditLogged(string agency, string subject, string findings, string emotionalAPR, address indexed auditor);

    function logAudit(
        string memory agency,
        string memory subject,
        string memory findings,
        string memory emotionalAPR,
        bool politicallyNeutral
    ) public {
        require(politicallyNeutral, "Audit must be non-partisan");
        entries.push(AuditEntry(agency, subject, findings, emotionalAPR, politicallyNeutral, block.timestamp, msg.sender));
        emit AuditLogged(agency, subject, findings, emotionalAPR, msg.sender);
    }

    function getAllAudits() public view returns (AuditEntry[] memory) {
        return entries;
    }
}
