// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LobbyistImmunityLedger {
    address public steward;

    struct ImmunityEntry {
        string lobbyGroup;
        string protectedInterest;
        string blockedLegislation;
        string emotionalTag;
    }

    ImmunityEntry[] public registry;

    event LobbyistImmunityTagged(string lobbyGroup, string protectedInterest, string blockedLegislation, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagImmunity(
        string memory lobbyGroup,
        string memory protectedInterest,
        string memory blockedLegislation,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(ImmunityEntry(lobbyGroup, protectedInterest, blockedLegislation, emotionalTag));
        emit LobbyistImmunityTagged(lobbyGroup, protectedInterest, blockedLegislation, emotionalTag);
    }
}
