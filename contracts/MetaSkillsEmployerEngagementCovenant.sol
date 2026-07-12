// SPDX-License-Identifier: MIT
// Contract Name: MetaSkillsEmployerEngagementCovenant
// Purpose: Encode employer buy-in, consensus building, and stakeholder alignment
// Source: Grounded in Spencer & Lucas 2021 (importance of employer buy-in + consensus)
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract MetaSkillsEmployerEngagementCovenant {
    address public chiefOperator;

    struct Engagement {
        string employer;    // e.g. Company name or sector
        string skill;       // e.g. Communicating, Integrity, Adapting
        string action;      // e.g. Pilot program, Training adoption, Consensus workshop
        string outcome;     // e.g. Buy-in, Alignment, Implementation
        uint256 timestamp;
    }

    Engagement[] public engagements;

    event EngagementLogged(string employer, string skill, string action, string outcome, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logEngagement(
        string memory employer,
        string memory skill,
        string memory action,
        string memory outcome
    ) public onlyChief {
        engagements.push(Engagement(employer, skill, action, outcome, block.timestamp));
        emit EngagementLogged(employer, skill, action, outcome, block.timestamp);
    }

    function getEngagement(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < engagements.length, "Invalid engagement index");
        Engagement memory e = engagements[index];
        return (e.employer, e.skill, e.action, e.outcome, e.timestamp);
    }
}
