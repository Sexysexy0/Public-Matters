// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LightningUtilityLedger {
    address public steward;

    struct UtilityEntry {
        string useCase;
        string LNMetric;
        string adoptionSignal;
        string emotionalTag;
    }

    UtilityEntry[] public ledger;

    event LightningUtilityTagged(string useCase, string LNMetric, string adoptionSignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagUtility(
        string memory useCase,
        string memory LNMetric,
        string memory adoptionSignal,
        string memory emotionalTag
    ) public onlySteward {
        ledger.push(UtilityEntry(useCase, LNMetric, adoptionSignal, emotionalTag));
        emit LightningUtilityTagged(useCase, LNMetric, adoptionSignal, emotionalTag);
    }
}
