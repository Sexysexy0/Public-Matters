// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeFiContagionLedger {
    address public steward;

    struct ContagionEntry {
        string protocolName;
        string failureTrigger;
        string contagionImpact;
        string emotionalTag;
    }

    ContagionEntry[] public registry;

    event DeFiContagionTagged(string protocolName, string failureTrigger, string contagionImpact, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagContagion(
        string memory protocolName,
        string memory failureTrigger,
        string memory contagionImpact,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(ContagionEntry(protocolName, failureTrigger, contagionImpact, emotionalTag));
        emit DeFiContagionTagged(protocolName, failureTrigger, contagionImpact, emotionalTag);
    }
}
