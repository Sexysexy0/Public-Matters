// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BudgetKarmaReallocationTreaty {
    address public steward;

    struct ReallocationClause {
        string department;
        string karmaSignal;
        string reallocationStrategy;
        string emotionalTag;
    }

    ReallocationClause[] public treatyLog;

    event BudgetReallocated(string department, string karmaSignal, string reallocationStrategy, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function reallocateBudget(
        string memory department,
        string memory karmaSignal,
        string memory reallocationStrategy,
        string memory emotionalTag
    ) public onlySteward {
        treatyLog.push(ReallocationClause(department, karmaSignal, reallocationStrategy, emotionalTag));
        emit BudgetReallocated(department, karmaSignal, reallocationStrategy, emotionalTag);
    }
}
