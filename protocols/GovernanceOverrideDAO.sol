// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GovernanceOverrideDAO {
    address public steward;

    struct OverrideEntry {
        string protocolName;
        string overrideTrigger;
        string governanceAction;
        string emotionalTag;
    }

    OverrideEntry[] public registry;

    event GovernanceOverrideTagged(string protocolName, string overrideTrigger, string governanceAction, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagOverride(
        string memory protocolName,
        string memory overrideTrigger,
        string memory governanceAction,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(OverrideEntry(protocolName, overrideTrigger, governanceAction, emotionalTag));
        emit GovernanceOverrideTagged(protocolName, overrideTrigger, governanceAction, emotionalTag);
    }
}
