// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// LivelihoodMirror: record livelihood programs linked to relocation sites
contract LivelihoodMirror {
    struct Program {
        uint256 id;
        string site;
        string program;    // "Skills Training", "Microfinance", "Job Fair"
        uint256 participants;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Program) public programs;
    mapping(address => bool) public stewards;

    event ProgramLogged(uint256 indexed id, string site, string program);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logProgram(string calldata site, string calldata program, uint256 participants) external {
        require(stewards[msg.sender], "Only steward");
        programs[nextId] = Program(nextId, site, program, participants, block.timestamp);
        emit ProgramLogged(nextId, site, program);
        nextId++;
    }
}
