// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DrainageSovereigntyCodex {
    address public steward;

    struct SovereigntyEntry {
        string barangay;
        string systemType;
        string sovereigntySignal;
        string emotionalTag;
    }

    SovereigntyEntry[] public codex;

    event DrainageSovereigntyTagged(string barangay, string systemType, string sovereigntySignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagSovereignty(
        string memory barangay,
        string memory systemType,
        string memory sovereigntySignal,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(SovereigntyEntry(barangay, systemType, sovereigntySignal, emotionalTag));
        emit DrainageSovereigntyTagged(barangay, systemType, sovereigntySignal, emotionalTag);
    }
}
