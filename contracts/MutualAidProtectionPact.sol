// SPDX-License-Identifier: MIT
// Contract Name: MutualAidProtectionPact
// Purpose: Guarantee mutual aid and collective support
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract MutualAidProtectionPact {
    address public chiefOperator;
    uint256 public pactCount;

    struct MutualAid {
        string domain;            // e.g., Workplace, Community, Global
        string aidRule;           // e.g., Shared assistance, Solidarity response, Anti-neglect safeguard
        string safeguard;         // e.g., Transparency log, Audit, Public record
        uint256 timestamp;
    }

    MutualAid[] public aids;

    event MutualAidAdded(string domain, string aidRule, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        pactCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new mutual aid protection pact
    function addMutualAid(string memory domain, string memory aidRule, string memory safeguard) public onlyChief {
        aids.push(MutualAid(domain, aidRule, safeguard, block.timestamp));
        pactCount++;
        emit MutualAidAdded(domain, aidRule, safeguard, block.timestamp);
    }

    // View mutual aid protection details
    function getMutualAid(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < aids.length, "Invalid mutual aid index");
        MutualAid memory m = aids[index];
        return (m.domain, m.aidRule, m.safeguard, m.timestamp);
    }
}
