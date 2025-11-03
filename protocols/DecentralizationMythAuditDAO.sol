// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizationMythAuditDAO {
    address public steward;

    struct MythEntry {
        string protocolName;
        string mythClaim;
        string auditFinding;
        string emotionalTag;
    }

    MythEntry[] public registry;

    event DecentralizationMythTagged(string protocolName, string mythClaim, string auditFinding, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagMyth(
        string memory protocolName,
        string memory mythClaim,
        string memory auditFinding,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(MythEntry(protocolName, mythClaim, auditFinding, emotionalTag));
        emit DecentralizationMythTagged(protocolName, mythClaim, auditFinding, emotionalTag);
    }
}
