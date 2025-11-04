// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BudgetRedemptionAllocationTreaty {
    address public steward;

    struct AllocationClause {
        string department;
        string redemptionSignal;
        string allocationStrategy;
        string emotionalTag;
    }

    AllocationClause[] public treatyLog;

    event BudgetRedeemed(string department, string redemptionSignal, string allocationStrategy, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function redeemBudget(
        string memory department,
        string memory redemptionSignal,
        string memory allocationStrategy,
        string memory emotionalTag
    ) public onlySteward {
        treatyLog.push(AllocationClause(department, redemptionSignal, allocationStrategy, emotionalTag));
        emit BudgetRedeemed(department, redemptionSignal, allocationStrategy, emotionalTag);
    }
}
