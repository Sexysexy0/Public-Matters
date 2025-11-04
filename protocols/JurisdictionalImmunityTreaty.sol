// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract JurisdictionalImmunityTreaty {
    address public steward;

    struct ImmunityClause {
        string jurisdiction;
        string legalThreat;
        string immunityFramework;
        string emotionalTag;
    }

    ImmunityClause[] public treatyLog;

    event JurisdictionalImmunityTagged(string jurisdiction, string legalThreat, string immunityFramework, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagImmunity(
        string memory jurisdiction,
        string memory legalThreat,
        string memory immunityFramework,
        string memory emotionalTag
    ) public onlySteward {
        treatyLog.push(ImmunityClause(jurisdiction, legalThreat, immunityFramework, emotionalTag));
        emit JurisdictionalImmunityTagged(jurisdiction, legalThreat, immunityFramework, emotionalTag);
    }
}
