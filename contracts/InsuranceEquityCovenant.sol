// SPDX-License-Identifier: MIT
// Contract Name: InsuranceEquityCovenant
// Purpose: Guarantee fair access to insurance benefits
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract InsuranceEquityCovenant {
    address public chiefOperator;
    uint256 public covenantCount;

    struct Insurance {
        string coverageType;    // e.g., Health, Accident, Life
        string equityRule;      // e.g., Equal access, Non-discrimination
        string safeguard;       // e.g., Transparency log, Audit trail
        uint256 timestamp;
    }

    Insurance[] public insurances;

    event InsuranceAdded(string coverageType, string equityRule, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        covenantCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new insurance covenant
    function addInsurance(string memory coverageType, string memory equityRule, string memory safeguard) public onlyChief {
        insurances.push(Insurance(coverageType, equityRule, safeguard, block.timestamp));
        covenantCount++;
        emit InsuranceAdded(coverageType, equityRule, safeguard, block.timestamp);
    }

    // View insurance covenant details
    function getInsurance(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < insurances.length, "Invalid insurance index");
        Insurance memory i = insurances[index];
        return (i.coverageType, i.equityRule, i.safeguard, i.timestamp);
    }
}
