// SPDX-License-Identifier: MIT
// Contract Name: MetaSkillsLearnerAgencyCovenant
// Purpose: Encode learner agency and co-agency principles in meta-skills development
// Source: Grounded in Spencer & Lucas 2021 findings on agency + SDS framework
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract MetaSkillsLearnerAgencyCovenant {
    address public chiefOperator;

    struct AgencyRecord {
        string learner;     // learner ID or name
        string skill;       // e.g. Initiative, Curiosity, Collaborating
        string agencyType;  // e.g. Agency, Co-agency
        string action;      // e.g. Self-directed project, Peer collaboration
        uint256 timestamp;
    }

    AgencyRecord[] public records;

    event AgencyLogged(string learner, string skill, string agencyType, string action, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logAgency(
        string memory learner,
        string memory skill,
        string memory agencyType,
        string memory action
    ) public onlyChief {
        records.push(AgencyRecord(learner, skill, agencyType, action, block.timestamp));
        emit AgencyLogged(learner, skill, agencyType, action, block.timestamp);
    }

    function getAgency(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < records.length, "Invalid agency index");
        AgencyRecord memory ar = records[index];
        return (ar.learner, ar.skill, ar.agencyType, ar.action, ar.timestamp);
    }
}
