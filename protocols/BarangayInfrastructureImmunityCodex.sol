// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BarangayInfrastructureImmunityCodex {
    address public steward;

    struct ImmunityEntry {
        string barangay;
        string projectType;
        string immunitySignal;
        string emotionalTag;
    }

    ImmunityEntry[] public codex;

    event BarangayInfrastructureTagged(string barangay, string projectType, string immunitySignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagImmunity(
        string memory barangay,
        string memory projectType,
        string memory immunitySignal,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(ImmunityEntry(barangay, projectType, immunitySignal, emotionalTag));
        emit BarangayInfrastructureTagged(barangay, projectType, immunitySignal, emotionalTag);
    }
}
