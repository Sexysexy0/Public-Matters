// SPDX-License-Identifier: MIT
// Contract Name: MetaSkillsLongitudinalCovenant
// Purpose: Encode long-term evaluation of meta-skills development
// Source: Grounded in Spencer & Lucas 2021 (noted absence of longitudinal evaluation)
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract MetaSkillsLongitudinalCovenant {
    address public chiefOperator;

    struct LongitudinalRecord {
        string skill;       // e.g. Integrity, Adapting, Curiosity
        string context;     // e.g. Apprenticeship, Workplace, Governance
        string metric;      // e.g. Reflection logs, Peer feedback, Performance data
        string trend;       // e.g. Improvement, Decline, Stable
        uint256 timestamp;
    }

    LongitudinalRecord[] public records;

    event LongitudinalLogged(string skill, string context, string metric, string trend, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logLongitudinal(
        string memory skill,
        string memory context,
        string memory metric,
        string memory trend
    ) public onlyChief {
        records.push(LongitudinalRecord(skill, context, metric, trend, block.timestamp));
        emit LongitudinalLogged(skill, context, metric, trend, block.timestamp);
    }

    function getLongitudinal(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < records.length, "Invalid longitudinal index");
        LongitudinalRecord memory lr = records[index];
        return (lr.skill, lr.context, lr.metric, lr.trend, lr.timestamp);
    }
}
