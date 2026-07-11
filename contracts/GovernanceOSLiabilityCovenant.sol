// SPDX-License-Identifier: MIT
// Contract Name: GovernanceOSLiabilityCovenant
// Purpose: Encodes liability protections, sanctions, and restitution mechanisms
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract GovernanceOSLiabilityCovenant {
    address public chiefOperator;
    uint256 public covenantCount;

    struct Liability {
        string role;          // Role or position
        string breach;        // Violation or failure
        string remedy;        // Sanction, restitution, or corrective measure
        uint256 timestamp;
    }

    Liability[] public liabilities;

    event LiabilityApplied(string role, string breach, string remedy, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        covenantCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function applyLiability(string memory role, string memory breach, string memory remedy) public onlyChief {
        liabilities.push(Liability(role, breach, remedy, block.timestamp));
        covenantCount++;
        emit LiabilityApplied(role, breach, remedy, block.timestamp);
    }

    function getLiability(uint256 index) public view returns (
        string memory, string memory, string memory, uint256
    ) {
        require(index < liabilities.length, "Invalid liability index");
        Liability memory l = liabilities[index];
        return (l.role, l.breach, l.remedy, l.timestamp);
    }
}
