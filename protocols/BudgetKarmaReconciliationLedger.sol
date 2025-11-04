// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BudgetKarmaReconciliationLedger {
    address public steward;

    struct ReconciliationEntry {
        string department;
        string karmaSignal;
        string reconciliationAction;
        string emotionalTag;
    }

    ReconciliationEntry[] public ledger;

    event BudgetKarmaReconciled(string department, string karmaSignal, string reconciliationAction, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function reconcileKarma(
        string memory department,
        string memory karmaSignal,
        string memory reconciliationAction,
        string memory emotionalTag
    ) public onlySteward {
        ledger.push(ReconciliationEntry(department, karmaSignal, reconciliationAction, emotionalTag));
        emit BudgetKarmaReconciled(department, karmaSignal, reconciliationAction, emotionalTag);
    }
}
