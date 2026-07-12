// SPDX-License-Identifier: MIT
// Contract Name: MetaSkillsAdoptionCovenant
// Purpose: Encode actual uptake + implementation of meta-skills framework across organisations
// Source: Grounded in Spencer & Lucas 2021 (importance of adoption + embedding in practice)
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract MetaSkillsAdoptionCovenant {
    address public chiefOperator;

    struct AdoptionRecord {
        string organisation; // e.g. Employer, School, Training Provider
        string skill;        // e.g. Communicating, Creativity, Integrity
        string action;       // e.g. Embedded in curriculum, Workplace training, Apprenticeship module
        string outcome;      // e.g. Adoption, Implementation, Scaling
        uint256 timestamp;
    }

    AdoptionRecord[] public records;

    event AdoptionLogged(string organisation, string skill, string action, string outcome, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logAdoption(
        string memory organisation,
        string memory skill,
        string memory action,
        string memory outcome
    ) public onlyChief {
        records.push(AdoptionRecord(organisation, skill, action, outcome, block.timestamp));
        emit AdoptionLogged(organisation, skill, action, outcome, block.timestamp);
    }

    function getAdoption(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < records.length, "Invalid adoption index");
        AdoptionRecord memory ar = records[index];
        return (ar.organisation, ar.skill, ar.action, ar.outcome, ar.timestamp);
    }
}
