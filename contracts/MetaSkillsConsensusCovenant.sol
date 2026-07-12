// SPDX-License-Identifier: MIT
// Contract Name: MetaSkillsConsensusCovenant
// Purpose: Encode stakeholder consensus + definition alignment for meta-skills
// Source: Grounded in Spencer & Lucas 2021 (importance of consensus + clarity of definitions)
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract MetaSkillsConsensusCovenant {
    address public chiefOperator;

    struct ConsensusRecord {
        string stakeholder; // e.g. Employer, Educator, Learner, Policy-maker
        string definition;  // agreed wording/meaning of a meta-skill
        string process;     // e.g. Workshop, Consultation, Roundtable
        string outcome;     // e.g. Alignment, Agreement, Adoption
        uint256 timestamp;
    }

    ConsensusRecord[] public records;

    event ConsensusLogged(string stakeholder, string definition, string process, string outcome, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logConsensus(
        string memory stakeholder,
        string memory definition,
        string memory process,
        string memory outcome
    ) public onlyChief {
        records.push(ConsensusRecord(stakeholder, definition, process, outcome, block.timestamp));
        emit ConsensusLogged(stakeholder, definition, process, outcome, block.timestamp);
    }

    function getConsensus(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < records.length, "Invalid consensus index");
        ConsensusRecord memory cr = records[index];
        return (cr.stakeholder, cr.definition, cr.process, cr.outcome, cr.timestamp);
    }
}
