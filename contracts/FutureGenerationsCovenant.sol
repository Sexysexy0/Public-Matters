// SPDX-License-Identifier: MIT
// Contract Name: FutureGenerationsCovenant
// Purpose: Guarantee protection and benefit for future generations
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract FutureGenerationsCovenant {
    address public chiefOperator;
    uint256 public covenantCount;

    struct Legacy {
        string domain;          // e.g., Environment, Education, Governance
        string futureRule;      // e.g., Sustainability, Long-term planning, Equal inheritance
        string safeguard;       // e.g., Transparency log, Audit, Public record
        uint256 timestamp;
    }

    Legacy[] public legacies;

    event LegacyAdded(string domain, string futureRule, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        covenantCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new future generations covenant
    function addLegacy(string memory domain, string memory futureRule, string memory safeguard) public onlyChief {
        legacies.push(Legacy(domain, futureRule, safeguard, block.timestamp));
        covenantCount++;
        emit LegacyAdded(domain, futureRule, safeguard, block.timestamp);
    }

    // View future generations covenant details
    function getLegacy(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < legacies.length, "Invalid legacy index");
        Legacy memory l = legacies[index];
        return (l.domain, l.futureRule, l.safeguard, l.timestamp);
    }
}
