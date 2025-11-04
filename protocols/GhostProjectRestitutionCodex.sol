// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GhostProjectRestitutionCodex {
    address public steward;

    struct RestitutionEntry {
        string projectName;
        string restitutionType;
        string communitySignal;
        string emotionalTag;
    }

    RestitutionEntry[] public codex;

    event GhostProjectRestituted(string projectName, string restitutionType, string communitySignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function restituteProject(
        string memory projectName,
        string memory restitutionType,
        string memory communitySignal,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(RestitutionEntry(projectName, restitutionType, communitySignal, emotionalTag));
        emit GhostProjectRestituted(projectName, restitutionType, communitySignal, emotionalTag);
    }
}
