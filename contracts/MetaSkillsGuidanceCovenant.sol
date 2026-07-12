// SPDX-License-Identifier: MIT
// Contract Name: MetaSkillsGuidanceCovenant
// Purpose: Encode provision of guidance + employer buy-in for meta-skills deployment
// Source: Grounded in Spencer & Lucas 2021 recommendations (guidance, consensus, employer engagement)
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract MetaSkillsGuidanceCovenant {
    address public chiefOperator;

    struct GuidanceRecord {
        string stakeholder; // e.g. Employer, Educator, Learner, Policy-maker
        string skill;       // e.g. Communicating, Integrity, Adapting
        string guidance;    // e.g. Clear definition, Progression framework, Practical example
        string outcome;     // e.g. Buy-in, Consensus, Adoption
        uint256 timestamp;
    }

    GuidanceRecord[] public records;

    event GuidanceLogged(string stakeholder, string skill, string guidance, string outcome, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logGuidance(
        string memory stakeholder,
        string memory skill,
        string memory guidance,
        string memory outcome
    ) public onlyChief {
        records.push(GuidanceRecord(stakeholder, skill, guidance, outcome, block.timestamp));
        emit GuidanceLogged(stakeholder, skill, guidance, outcome, block.timestamp);
    }

    function getGuidance(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < records.length, "Invalid guidance index");
        GuidanceRecord memory gr = records[index];
        return (gr.stakeholder, gr.skill, gr.guidance, gr.outcome, gr.timestamp);
    }
}
