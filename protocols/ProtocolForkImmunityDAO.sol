// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProtocolForkImmunityDAO {
    address public steward;

    struct ForkImmunityEntry {
        string protocolName;
        string forkTrigger;
        string immunityFramework;
        string emotionalTag;
    }

    ForkImmunityEntry[] public registry;

    event ProtocolForkImmunityTagged(string protocolName, string forkTrigger, string immunityFramework, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagForkImmunity(
        string memory protocolName,
        string memory forkTrigger,
        string memory immunityFramework,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(ForkImmunityEntry(protocolName, forkTrigger, immunityFramework, emotionalTag));
        emit ProtocolForkImmunityTagged(protocolName, forkTrigger, immunityFramework, emotionalTag);
    }
}
