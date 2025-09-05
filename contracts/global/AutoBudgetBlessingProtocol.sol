// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

contract AutoBudgetBlessingProtocol {
    struct BudgetStrike {
        uint256 missedDeadline;
        uint8 strikeLevel;
        string consequence;
    }

    mapping(address => BudgetStrike[]) public budgetLog;
    event BudgetPenalty(address indexed steward, uint8 strikeLevel, string consequence, uint256 timestamp);

    function logStrike(address steward, uint256 deadlineMissed, uint8 level) external {
        string memory consequence;
        if (level == 1) consequence = "No salary for 1 month, rerouted to district";
        else if (level == 2) consequence = "No salary for 6 months, rerouted to district";
        else if (level == 3) consequence = "No salary for 3 years, rerouted again + optional retirement";

        budgetLog[steward].push(BudgetStrike(deadlineMissed, level, consequence));
        emit BudgetPenalty(steward, level, consequence, block.timestamp);
    }

    function getLatestStrike(address steward) external view returns (BudgetStrike memory) {
        uint256 len = budgetLog[steward].length;
        require(len > 0, "No strikes recorded");
        return budgetLog[steward][len - 1];
    }
}
