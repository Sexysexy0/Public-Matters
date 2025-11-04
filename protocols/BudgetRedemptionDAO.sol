// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BudgetRedemptionDAO {
    address public steward;

    struct RedemptionEntry {
        string department;
        string redemptionSignal;
        string reallocationPath;
        string emotionalTag;
    }

    RedemptionEntry[] public registry;

    event BudgetRedeemed(string department, string redemptionSignal, string reallocationPath, string emotionalTag);

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
        string memory reallocationPath,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(RedemptionEntry(department, redemptionSignal, reallocationPath, emotionalTag));
        emit BudgetRedeemed(department, redemptionSignal, reallocationPath, emotionalTag);
    }
}
