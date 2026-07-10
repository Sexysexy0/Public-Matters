// SPDX-License-Identifier: MIT
// Contract Name: ProfessionalDevelopmentTrainingPolicy
// Purpose: Support employee growth through training and career development
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract ProfessionalDevelopmentTrainingPolicy {
    address public chiefOperator;
    uint256 public programCount;

    struct Program {
        string principle;
        string supportMechanism;
        uint256 timestamp;
    }

    Program[] public programs;

    event ProgramAdded(string principle, string supportMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        programCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new training/development clause
    function addProgram(string memory principle, string memory supportMechanism) public onlyChief {
        programs.push(Program(principle, supportMechanism, block.timestamp));
        programCount++;
        emit ProgramAdded(principle, supportMechanism, block.timestamp);
    }

    // View training/development clause details
    function getProgram(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < programs.length, "Invalid program index");
        Program memory p = programs[index];
        return (p.principle, p.supportMechanism, p.timestamp);
    }
}
