// SPDX-License-Identifier: MIT
// Contract Name: BudgetUtilizationOptimizationCovenant
// Purpose: Safeguard against low utilization and over-allocation of funds
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract BudgetUtilizationOptimizationCovenant {
    address public chiefOperator;
    uint256 public covenantCount;

    struct Covenant {
        string domain;        // e.g., Budget, Utilization, Allocation
        string rule;          // e.g., No over-allocation, timely implementation
        string safeguard;     // e.g., monthly audit, utilization threshold
        uint256 timestamp;
    }

    Covenant[] public covenants;

    event CovenantAdded(string domain, string rule, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        covenantCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function addCovenant(string memory domain, string memory rule, string memory safeguard) public onlyChief {
        covenants.push(Covenant(domain, rule, safeguard, block.timestamp));
        covenantCount++;
        emit CovenantAdded(domain, rule, safeguard, block.timestamp);
    }

    function getCovenant(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < covenants.length, "Invalid covenant index");
        Covenant memory c = covenants[index];
        return (c.domain, c.rule, c.safeguard, c.timestamp);
    }
}
