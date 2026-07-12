// SPDX-License-Identifier: MIT
// Contract Name: MetaSkillsVocationalCovenant
// Purpose: Encode vocational context + TVET integration for meta-skills
// Source: Grounded in Spencer & Lucas 2021 (TVET + work-based learning emphasis)
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract MetaSkillsVocationalCovenant {
    address public chiefOperator;

    struct VocationalRecord {
        string skill;       // e.g. Collaborating, Communicating, Adapting
        string program;     // e.g. Apprenticeship, TVET, Workplace training
        string method;      // e.g. Infusion model, Work-based project, Simulation
        string outcome;     // e.g. Employability, Resilience, Transferability
        uint256 timestamp;
    }

    VocationalRecord[] public records;

    event VocationalLogged(string skill, string program, string method, string outcome, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logVocational(
        string memory skill,
        string memory program,
        string memory method,
        string memory outcome
    ) public onlyChief {
        records.push(VocationalRecord(skill, program, method, outcome, block.timestamp));
        emit VocationalLogged(skill, program, method, outcome, block.timestamp);
    }

    function getVocational(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < records.length, "Invalid vocational index");
        VocationalRecord memory vr = records[index];
        return (vr.skill, vr.program, vr.method, vr.outcome, vr.timestamp);
    }
}
