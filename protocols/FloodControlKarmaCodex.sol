// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FloodControlKarmaCodex {
    address public steward;

    struct KarmaEntry {
        string projectLocation;
        string karmaSignal;
        string consequenceType;
        string emotionalTag;
    }

    KarmaEntry[] public codex;

    event FloodControlKarmaTagged(string projectLocation, string karmaSignal, string consequenceType, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagKarma(
        string memory projectLocation,
        string memory karmaSignal,
        string memory consequenceType,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(KarmaEntry(projectLocation, karmaSignal, consequenceType, emotionalTag));
        emit FloodControlKarmaTagged(projectLocation, karmaSignal, consequenceType, emotionalTag);
    }
}
