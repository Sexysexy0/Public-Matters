// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GlobalJurisdictionAuditCodex {
    address public steward;

    struct AuditEntry {
        string jurisdiction;
        string enforcementPattern;
        string developerImpact;
        string emotionalTag;
    }

    AuditEntry[] public codex;

    event JurisdictionAuditLogged(string jurisdiction, string enforcementPattern, string developerImpact, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function logAudit(
        string memory jurisdiction,
        string memory enforcementPattern,
        string memory developerImpact,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(AuditEntry(jurisdiction, enforcementPattern, developerImpact, emotionalTag));
        emit JurisdictionAuditLogged(jurisdiction, enforcementPattern, developerImpact, emotionalTag);
    }
}
