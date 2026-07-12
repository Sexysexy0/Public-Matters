// SPDX-License-Identifier: MIT
// Contract Name: MetaSkillsProgressionCovenant
// Purpose: Encode progression framework for meta-skills (Self-management, Social intelligence, Innovation)
// Source: Adapted from SDS Meta-Skills Progression Framework + Spencer & Lucas 2021
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract MetaSkillsProgressionCovenant {
    address public chiefOperator;

    struct MetaSkill {
        string cluster;      // e.g. Self-management, Social intelligence, Innovation
        string skill;        // e.g. Integrity, Communicating, Curiosity
        string progression;  // e.g. Early Level → Senior Phase descriptors
        uint256 timestamp;
    }

    MetaSkill[] public skills;

    event SkillLogged(string cluster, string skill, string progression, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logSkill(string memory cluster, string memory skill, string memory progression) public onlyChief {
        skills.push(MetaSkill(cluster, skill, progression, block.timestamp));
        emit SkillLogged(cluster, skill, progression, block.timestamp);
    }

    function getSkill(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < skills.length, "Invalid skill index");
        MetaSkill memory ms = skills[index];
        return (ms.cluster, ms.skill, ms.progression, ms.timestamp);
    }
}
