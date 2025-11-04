// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FloodControlKarmaImmunityLedger {
    address public steward;

    struct ImmunityEntry {
        string projectLocation;
        string karmaSignal;
        string immunityProtocol;
        string emotionalTag;
    }

    ImmunityEntry[] public ledger;

    event FloodControlKarmaImmunized(string projectLocation, string karmaSignal, string immunityProtocol, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function immunizeKarma(
        string memory projectLocation,
        string memory karmaSignal,
        string memory immunityProtocol,
        string memory emotionalTag
    ) public onlySteward {
        ledger.push(ImmunityEntry(projectLocation, karmaSignal, immunityProtocol, emotionalTag));
        emit FloodControlKarmaImmunized(projectLocation, karmaSignal, immunityProtocol, emotionalTag);
    }
}
