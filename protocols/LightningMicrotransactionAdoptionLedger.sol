// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LightningMicrotransactionAdoptionLedger {
    address public steward;

    struct AdoptionEntry {
        string region;
        string useCase;
        string adoptionMetric;
        string emotionalTag;
    }

    AdoptionEntry[] public ledger;

    event LightningMicrotransactionAdoptionTagged(string region, string useCase, string adoptionMetric, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagAdoption(
        string memory region,
        string memory useCase,
        string memory adoptionMetric,
        string memory emotionalTag
    ) public onlySteard {
        ledger.push(AdoptionEntry(region, useCase, adoptionMetric, emotionalTag));
        emit LightningMicrotransactionAdoptionTagged(region, useCase, adoptionMetric, emotionalTag);
    }
}
