// SPDX-License-Identifier: MIT
// Contract Name: GlobalLaborAndFairWorkCovenant
// Purpose: Safeguards fair wages, safe working conditions, and dignity in labor
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract GlobalLaborAndFairWorkCovenant {
    address public chiefOperator;
    uint256 public covenantCount;

    struct Covenant {
        string domain;        // Labor, Work, Governance
        string rule;          // Labor safeguard clause
        string safeguard;     // Fairness, safety, dignity
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

    function getCovenant(uint256 index) public view returns (
        string memory, string memory, string memory, uint256
    ) {
        require(index < covenants.length, "Invalid covenant index");
        Covenant memory c = covenants[index];
        return (c.domain, c.rule, c.safeguard, c.timestamp);
    }
}
