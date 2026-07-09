// SPDX-License-Identifier: MIT
// Contract Name: UnityOfDiversityCharter
// Purpose: Guarantee respect and inclusion of diversity
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract UnityOfDiversityCharter {
    address public chiefOperator;
    uint256 public charterCount;

    struct Diversity {
        string domain;           // e.g., Workplace, Community, Digital
        string diversityRule;    // e.g., Inclusion, Cultural recognition, Equal voice
        string safeguard;        // e.g., Transparency log, Audit, Public record
        uint256 timestamp;
    }

    Diversity[] public diversities;

    event DiversityAdded(string domain, string diversityRule, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        charterCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new unity of diversity charter
    function addDiversity(string memory domain, string memory diversityRule, string memory safeguard) public onlyChief {
        diversities.push(Diversity(domain, diversityRule, safeguard, block.timestamp));
        charterCount++;
        emit DiversityAdded(domain, diversityRule, safeguard, block.timestamp);
    }

    // View unity of diversity details
    function getDiversity(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < diversities.length, "Invalid diversity index");
        Diversity memory d = diversities[index];
        return (d.domain, d.diversityRule, d.safeguard, d.timestamp);
    }
}
