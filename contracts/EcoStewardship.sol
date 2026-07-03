// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EcoStewardship
/// @notice Covenant to safeguard environmental programs,
///         ensuring tree planting, river rehabilitation, and water savings.
contract EcoStewardship {
    address public overseer;
    uint256 public programCount;

    struct Program {
        uint256 id;
        string initiative;   // TreePlanting, RiverRehab, WaterSavings
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Program) public programs;

    event ProgramDeclared(uint256 indexed id, string initiative, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function declareProgram(string calldata initiative, string calldata description) external onlyOverseer {
        programCount++;
        programs[programCount] = Program(programCount, initiative, description, block.timestamp);
        emit ProgramDeclared(programCount, initiative, description);
    }

    function viewProgram(uint256 id) external view returns (Program memory) {
        return programs[id];
    }
}
