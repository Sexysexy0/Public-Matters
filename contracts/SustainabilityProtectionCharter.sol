// SPDX-License-Identifier: MIT
// Contract Name: SustainabilityProtectionCharter
// Purpose: Guarantee sustainability and protection of resources
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract SustainabilityProtectionCharter {
    address public chiefOperator;
    uint256 public charterCount;

    struct Sustainability {
        string domain;             // e.g., Workplace, Community, Global
        string sustainabilityRule; // e.g., Environmental balance, Resource stewardship, Anti-exploitation safeguard
        string safeguard;          // e.g., Transparency log, Audit, Public record
        uint256 timestamp;
    }

    Sustainability[] public sustainabilities;

    event SustainabilityAdded(string domain, string sustainabilityRule, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        charterCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new sustainability protection charter
    function addSustainability(string memory domain, string memory sustainabilityRule, string memory safeguard) public onlyChief {
        sustainabilities.push(Sustainability(domain, sustainabilityRule, safeguard, block.timestamp));
        charterCount++;
        emit SustainabilityAdded(domain, sustainabilityRule, safeguard, block.timestamp);
    }

    // View sustainability protection details
    function getSustainability(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < sustainabilities.length, "Invalid sustainability index");
        Sustainability memory s = sustainabilities[index];
        return (s.domain, s.sustainabilityRule, s.safeguard, s.timestamp);
    }
}
