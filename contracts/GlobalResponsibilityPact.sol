// SPDX-License-Identifier: MIT
// Contract Name: GlobalResponsibilityPact
// Purpose: Guarantee shared global responsibility and accountability
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract GlobalResponsibilityPact {
    address public chiefOperator;
    uint256 public pactCount;

    struct Responsibility {
        string domain;          // e.g., Environment, Trade, Humanitarian aid
        string responsibilityRule; // e.g., Shared duty, Equal accountability, Non-exploitation
        string safeguard;       // e.g., Transparency log, Audit, Public record
        uint256 timestamp;
    }

    Responsibility[] public responsibilities;

    event ResponsibilityAdded(string domain, string responsibilityRule, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        pactCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new global responsibility pact
    function addResponsibility(string memory domain, string memory responsibilityRule, string memory safeguard) public onlyChief {
        responsibilities.push(Responsibility(domain, responsibilityRule, safeguard, block.timestamp));
        pactCount++;
        emit ResponsibilityAdded(domain, responsibilityRule, safeguard, block.timestamp);
    }

    // View global responsibility details
    function getResponsibility(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < responsibilities.length, "Invalid responsibility index");
        Responsibility memory r = responsibilities[index];
        return (r.domain, r.responsibilityRule, r.safeguard, r.timestamp);
    }
}
