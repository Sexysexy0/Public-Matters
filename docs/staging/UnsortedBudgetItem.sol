// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract UnsortedBudgetItem {
    struct BudgetItem {
        string agency;
        string description;
        uint256 amount;
        bool barangayTagged;
        bool stewardIncluded;
        uint256 timestamp;
    }

    BudgetItem[] public items;
    address public steward;

    event BudgetItemLogged(string agency, string description, uint256 amount);

    constructor() {
        steward = msg.sender;
    }

    function logItem(
        string memory agency,
        string memory description,
        uint256 amount,
        bool tagged,
        bool included
    ) external {
        require(msg.sender == steward, "Unauthorized steward");

        items.push(BudgetItem(agency, description, amount, tagged, included, block.timestamp));
        emit BudgetItemLogged(agency, description, amount);
    }

    function getItem(uint256 index) external view returns (BudgetItem memory) {
        return items[index];
    }
}
