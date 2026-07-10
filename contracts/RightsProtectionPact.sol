// SPDX-License-Identifier: MIT
// Contract Name: RightsProtectionPact
// Purpose: Guarantee protection of fundamental rights
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract RightsProtectionPact {
    address public chiefOperator;
    uint256 public pactCount;

    struct RightProtection {
        string domain;          // e.g., Workplace, Community, Digital
        string protectionRule;  // e.g., Equal safeguard, Non-violation, Enforcement clause
        string safeguard;       // e.g., Transparency log, Audit, Public record
        uint256 timestamp;
    }

    RightProtection[] public protections;

    event ProtectionAdded(string domain, string protectionRule, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        pactCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new rights protection pact
    function addProtection(string memory domain, string memory protectionRule, string memory safeguard) public onlyChief {
        protections.push(RightProtection(domain, protectionRule, safeguard, block.timestamp));
        pactCount++;
        emit ProtectionAdded(domain, protectionRule, safeguard, block.timestamp);
    }

    // View rights protection details
    function getProtection(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < protections.length, "Invalid protection index");
        RightProtection memory rp = protections[index];
        return (rp.domain, rp.protectionRule, rp.safeguard, rp.timestamp);
    }
}
