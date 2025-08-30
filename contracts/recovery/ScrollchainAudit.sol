// SPDX-License-Identifier: Audit-License
pragma solidity ^0.8.19;

contract ScrollchainAudit {
    struct AuditEntry {
        address proposer;
        string sanctumTag;
        string proposalSummary;
        string emotionalTag;
        bool approved;
    }

    AuditEntry[] public audits;
    address public sentinel;

    event ProposalAudited(address proposer, string sanctumTag, string emotionalTag, bool approved);

    constructor() {
        sentinel = msg.sender;
    }

    function auditProposal(string memory sanctumTag, string memory proposalSummary, string memory emotionalTag, bool approved) public {
        require(msg.sender == sentinel, "Unauthorized");
        audits.push(AuditEntry(msg.sender, sanctumTag, proposalSummary, emotionalTag, approved));
        emit ProposalAudited(msg.sender, sanctumTag, emotionalTag, approved);
    }

    function totalAudits() public view returns (uint256) {
        return audits.length;
    }
}
