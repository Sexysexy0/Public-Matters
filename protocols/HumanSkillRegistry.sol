// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HumanSkillRegistry {
    struct Skill {
        string name;
        address owner;
        uint timestamp;
    }

    uint public skillCount;
    mapping(uint => Skill) public skills;
    mapping(address => uint[]) public skillsByOwner;

    event SkillRegistered(address indexed owner, string name, uint skillId);

    function registerSkill(string memory name) public {
        skillCount++;
        skills[skillCount] = Skill(name, msg.sender, block.timestamp);
        skillsByOwner[msg.sender].push(skillCount);
        emit SkillRegistered(msg.sender, name, skillCount);
    }

    function getSkills(address owner) public view returns (uint[] memory) {
        return skillsByOwner[owner];
    }
}
