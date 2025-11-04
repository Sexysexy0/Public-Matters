// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BarangayKarmaImmunityCodex {
    address public steward;

    struct ImmunityEntry {
        string barangay;
        string karmaSignal;
        string immunityMechanism;
        string emotionalTag;
    }

    ImmunityEntry[] public codex;

    event BarangayKarmaImmunityTagged(string barangay, string karmaSignal, string immunityMechanism, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagImmunity(
        string memory barangay,
        string memory karmaSignal,
        string memory immunityMechanism,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(ImmunityEntry(barangay, karmaSignal, immunityMechanism, emotionalTag));
        emit BarangayKarmaImmunityTagged(barangay, karmaSignal, immunityMechanism, emotionalTag);
    }
}
