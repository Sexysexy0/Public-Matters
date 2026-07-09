// SPDX-License-Identifier: MIT
// Contract Name: CommunityBenefitCharter
// Purpose: Guarantee fair distribution of community benefits
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract CommunityBenefitCharter {
    address public chiefOperator;
    uint256 public charterCount;

    struct Benefit {
        string benefitType;     // e.g., Housing, Education, Healthcare
        string distributionRule;// e.g., Equal share, Rotation, Need-based
        string safeguard;       // e.g., Transparency log, Audit trail
        uint256 timestamp;
    }

    Benefit[] public benefits;

    event BenefitAdded(string benefitType, string distributionRule, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        charterCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new community benefit
    function addBenefit(string memory benefitType, string memory distributionRule, string memory safeguard) public onlyChief {
        benefits.push(Benefit(benefitType, distributionRule, safeguard, block.timestamp));
        charterCount++;
        emit BenefitAdded(benefitType, distributionRule, safeguard, block.timestamp);
    }

    // View benefit details
    function getBenefit(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < benefits.length, "Invalid benefit index");
        Benefit memory b = benefits[index];
        return (b.benefitType, b.distributionRule, b.safeguard, b.timestamp);
    }
}
