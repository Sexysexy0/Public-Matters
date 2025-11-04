// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BudgetExecutionConfidenceLedger {
    address public steward;

    struct ConfidenceEntry {
        string department;
        string executionMetric;
        string confidenceSignal;
        string emotionalTag;
    }

    ConfidenceEntry[] public ledger;

    event BudgetConfidenceTagged(string department, string executionMetric, string confidenceSignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagConfidence(
        string memory department,
        string memory executionMetric,
        string memory confidenceSignal,
        string memory emotionalTag
    ) public onlySteward {
        ledger.push(ConfidenceEntry(department, executionMetric, confidenceSignal, emotionalTag));
        emit BudgetConfidenceTagged(department, executionMetric, confidenceSignal, emotionalTag);
    }
}
