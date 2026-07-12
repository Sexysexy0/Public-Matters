// SPDX-License-Identifier: MIT
// Contract Name: GovernanceMetaSkillsRegistry
// Purpose: Registry covenant for meta-skills clusters and training modules
pragma solidity ^0.8.20;

contract GovernanceMetaSkillsRegistry {
    address public chiefOperator;

    struct MetaSkill {
        string cluster;
        string skill;
        string attribute;
        bool active;
    }

    MetaSkill[] public skills;

    event SkillRegistered(string cluster, string skill, string attribute, bool active);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function registerSkill(string memory cluster, string memory skill, string memory attribute) public onlyChief {
        skills.push(MetaSkill(cluster, skill, attribute, true));
        emit SkillRegistered(cluster, skill, attribute, true);
    }

    function toggleSkill(uint256 index, bool status) public onlyChief {
        require(index < skills.length, "Invalid skill index");
        skills[index].active = status;
    }

    function getSkill(uint256 index) public view returns (string memory, string memory, string memory, bool) {
        require(index < skills.length, "Invalid skill index");
        MetaSkill memory ms = skills[index];
        return (ms.cluster, ms.skill, ms.attribute, ms.active);
    }
}
