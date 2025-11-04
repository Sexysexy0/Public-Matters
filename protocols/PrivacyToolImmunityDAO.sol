// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PrivacyToolImmunityDAO {
    address public steward;

    struct ImmunityEntry {
        string toolName;
        string legalThreat;
        string immunityFramework;
        string emotionalTag;
    }

    ImmunityEntry[] public registry;

    event PrivacyToolImmunityTagged(string toolName, string legalThreat, string immunityFramework, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagImmunity(
        string memory toolName,
        string memory legalThreat,
        string memory immunityFramework,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(ImmunityEntry(toolName, legalThreat, immunityFramework, emotionalTag));
        emit PrivacyToolImmunityTagged(toolName, legalThreat, immunityFramework, emotionalTag);
    }
}
