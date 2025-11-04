// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DrainageSystemIntegrityCodex {
    address public steward;

    struct IntegrityEntry {
        string projectLocation;
        string systemType;
        string integritySignal;
        string emotionalTag;
    }

    IntegrityEntry[] public codex;

    event DrainageIntegrityTagged(string projectLocation, string systemType, string integritySignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagIntegrity(
        string memory projectLocation,
        string memory systemType,
        string memory integritySignal,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(IntegrityEntry(projectLocation, systemType, integritySignal, emotionalTag));
        emit DrainageIntegrityTagged(projectLocation, systemType, integritySignal, emotionalTag);
    }
}
