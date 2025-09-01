// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BudgetSurgeLedger {
    struct Allocation {
        string category; // "Materials", "Labor", "Land", "APR Restoration"
        uint256 amount;
        string emotionalTag; // "AuditGlow", "DamayClause", etc.
        uint256 timestamp;
    }

    Allocation[] public allocations;

    function logAllocation(string memory category, uint256 amount, string memory emotionalTag) public {
        allocations.push(Allocation(category, amount, emotionalTag, block.timestamp));
    }

    function totalSpent() public view returns (uint256 total) {
        for (uint i = 0; i < allocations.length; i++) {
            total += allocations[i].amount;
        }
    }
}
