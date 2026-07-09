// SPDX-License-Identifier: MIT
// Contract Name: JusticeMasterCovenant
// Purpose: Constitution-style bundle of justice safeguards
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract JusticeMasterCovenant {
    address public chiefOperator;
    uint256 public covenantCount;

    struct Covenant {
        string domain;        // Equity, Integrity, Resilience, Sustainability, Containment, Rehabilitation, Restorative
        string rule;          // Safeguard clause
        string safeguard;     // Audit or feedback loop
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
