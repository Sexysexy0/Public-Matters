// SPDX-License-Identifier: MIT
// Contract Name: ParticipationCovenant
// Purpose: Encode direct involvement + democratic voice principles in governance
// Source: Grounded in Public Matters vision (participation, empowerment, solidarity, fairness)
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract ParticipationCovenant {
    address public chiefOperator;

    struct ParticipationRecord {
        string principle;   // e.g. Democratic voice, Direct involvement, Active governance
        string action;      // e.g. Public consultation, Voting mechanism, Sector dialogue
        string sector;      // e.g. Telecom, Finance, Utilities, Education
        string outcome;     // e.g. Participation upheld, Voice heard, Governance shared
        uint256 timestamp;
    }

    ParticipationRecord[] public records;

    event ParticipationLogged(string principle, string action, string sector, string outcome, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logParticipation(
        string memory principle,
        string memory action,
        string memory sector,
        string memory outcome
    ) public onlyChief {
        records.push(ParticipationRecord(principle, action, sector, outcome, block.timestamp));
        emit ParticipationLogged(principle, action, sector, outcome, block.timestamp);
    }

    function getParticipation(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < records.length, "Invalid participation index");
        ParticipationRecord memory pr = records[index];
        return (pr.principle, pr.action, pr.sector, pr.outcome, pr.timestamp);
    }
}
