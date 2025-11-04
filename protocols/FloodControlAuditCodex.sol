// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FloodControlAuditCodex {
    address public steward;

    struct AuditEntry {
        string projectLocation;
        string auditFinding;
        string accountabilitySignal;
        string emotionalTag;
    }

    AuditEntry[] public codex;

    event FloodControlAudited(string projectLocation, string auditFinding, string accountabilitySignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagAudit(
        string memory projectLocation,
        string memory auditFinding,
        string memory accountabilitySignal,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(AuditEntry(projectLocation, auditFinding, accountabilitySignal, emotionalTag));
        emit FloodControlAudited(projectLocation, auditFinding, accountabilitySignal, emotionalTag);
    }
}
