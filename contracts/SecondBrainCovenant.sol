// SPDX-License-Identifier: MIT
// Contract Name: SecondBrainCovenant
// Purpose: Safeguard centralized documentation and project logic control
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract SecondBrainCovenant {
    address public chiefOperator;
    uint256 public covenantCount;

    struct Covenant {
        string principle;
        string documentationMechanism;
        uint256 timestamp;
    }

    Covenant[] public covenants;

    event CovenantAdded(string principle, string documentationMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        covenantCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new second brain clause
    function addCovenant(string memory principle, string memory documentationMechanism) public onlyChief {
        covenants.push(Covenant(principle, documentationMechanism, block.timestamp));
        covenantCount++;
        emit CovenantAdded(principle, documentationMechanism, block.timestamp);
    }

    // View covenant details
    function getCovenant(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < covenants.length, "Invalid covenant index");
        Covenant memory c = covenants[index];
        return (c.principle, c.documentationMechanism, c.timestamp);
    }
}
