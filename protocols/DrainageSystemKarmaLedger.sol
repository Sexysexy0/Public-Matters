// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DrainageSystemKarmaLedger {
    address public steward;

    struct KarmaEntry {
        string barangay;
        string systemType;
        string karmaSignal;
        string restitutionTag;
    }

    KarmaEntry[] public ledger;

    event DrainageKarmaTagged(string barangay, string systemType, string karmaSignal, string restitutionTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagKarma(
        string memory barangay,
        string memory systemType,
        string memory karmaSignal,
        string memory restitutionTag
    ) public onlySteward {
        ledger.push(KarmaEntry(barangay, systemType, karmaSignal, restitutionTag));
        emit DrainageKarmaTagged(barangay, systemType, karmaSignal, restitutionTag);
    }
}
