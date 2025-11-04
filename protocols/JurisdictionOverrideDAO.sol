// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract JurisdictionOverrideDAO {
    address public steward;

    struct OverrideEntry {
        string platformName;
        string jurisdiction;
        string overrideTrigger;
        string emotionalTag;
    }

    OverrideEntry[] public registry;

    event JurisdictionOverrideTagged(string platformName, string jurisdiction, string overrideTrigger, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagOverride(
        string memory platformName,
        string memory jurisdiction,
        string memory overrideTrigger,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(OverrideEntry(platformName, jurisdiction, overrideTrigger, emotionalTag));
        emit JurisdictionOverrideTagged(platformName, jurisdiction, overrideTrigger, emotionalTag);
    }
}
