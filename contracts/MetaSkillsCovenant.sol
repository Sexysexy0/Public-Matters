// SPDX-License-Identifier: MIT
// Contract Name: MetaSkillsCovenant
// Purpose: Encode meta-skills clusters (Self-Management, Social Intelligence, Innovation)
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract MetaSkillsCovenant {
    address public chiefOperator;
    uint256 public skillCount;

    struct MetaSkill {
        string cluster;   // Self-Management, Social Intelligence, Innovation
        string skill;     // e.g. Integrity, Communicating, Creativity
        string attribute; // supporting attribute (e.g. resilience, empathy, imagination)
        string trigger;   // workplace/governance event
        uint256 timestamp;
    }

    MetaSkill[] public skills;

    event SkillApplied(string cluster, string skill, string attribute, string trigger, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        skillCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function applySkill(string memory cluster, string memory skill, string memory attribute, string memory trigger) public onlyChief {
        skills.push(MetaSkill(cluster, skill, attribute, trigger, block.timestamp));
        skillCount++;
        emit SkillApplied(cluster, skill, attribute, trigger, block.timestamp);
    }

    function getSkill(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < skills.length, "Invalid skill index");
        MetaSkill memory ms = skills[index];
        return (ms.cluster, ms.skill, ms.attribute, ms.trigger, ms.timestamp);
    }
}
