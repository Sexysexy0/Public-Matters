// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeveloperImmunityProtocol {
    address public steward;

    struct ImmunityEntry {
        string protocolName;
        string legalThreat;
        string immunityFramework;
        string emotionalTag;
    }

    ImmunityEntry[] public registry;

    event DeveloperImmunityTagged(string protocolName, string legalThreat, string immunityFramework, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagImmunity(
        string memory protocolName,
        string memory legalThreat,
        string memory immunityFramework,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(ImmunityEntry(protocolName, legalThreat, immunityFramework, emotionalTag));
        emit DeveloperImmunityTagged(protocolName, legalThreat, immunityFramework, emotionalTag);
    }
}
