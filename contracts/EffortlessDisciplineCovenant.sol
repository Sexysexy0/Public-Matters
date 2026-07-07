// SPDX-License-Identifier: MIT
// Contract Name: EffortlessDisciplineCovenant
// Purpose: Encode discipline as meaning-aligned pursuit
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract EffortlessDisciplineCovenant {
    address public chiefOperator;
    uint256 public covenantCount;

    struct Covenant {
        string principle;
        string disciplineMechanism;
        uint256 timestamp;
    }

    Covenant[] public covenants;

    event CovenantAdded(string principle, string disciplineMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        covenantCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new discipline clause
    function addCovenant(string memory principle, string memory disciplineMechanism) public onlyChief {
        covenants.push(Covenant(principle, disciplineMechanism, block.timestamp));
        covenantCount++;
        emit CovenantAdded(principle, disciplineMechanism, block.timestamp);
    }

    // View covenant details
    function getCovenant(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < covenants.length, "Invalid covenant index");
        Covenant memory c = covenants[index];
        return (c.principle, c.disciplineMechanism, c.timestamp);
    }
}
