// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GhostProjectKarmaIndex {
    address public steward;

    struct KarmaEntry {
        string projectName;
        string karmaWeight;
        string restitutionSignal;
        string emotionalTag;
    }

    KarmaEntry[] public index;

    event GhostProjectKarmaTagged(string projectName, string karmaWeight, string restitutionSignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagKarma(
        string memory projectName,
        string memory karmaWeight,
        string memory restitutionSignal,
        string memory emotionalTag
    ) public onlySteward {
        index.push(KarmaEntry(projectName, karmaWeight, restitutionSignal, emotionalTag));
        emit GhostProjectKarmaTagged(projectName, karmaWeight, restitutionSignal, emotionalTag);
    }
}
