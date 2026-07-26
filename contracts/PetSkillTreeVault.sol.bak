// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PetSkillTreeVault {
    struct PetSkill {
        address owner;
        string petType;
        string ability;
        uint256 timestamp;
        bool unlocked;
    }

    PetSkill[] public petSkills;

    event PetSkillLogged(address indexed owner, string petType, string ability);
    event PetSkillUnlocked(uint256 indexed id, address verifier);

    function logPetSkill(string memory _petType, string memory _ability) public {
        petSkills.push(PetSkill(msg.sender, _petType, _ability, block.timestamp, false));
        emit PetSkillLogged(msg.sender, _petType, _ability);
    }

    function unlockPetSkill(uint256 _id) public {
        require(_id < petSkills.length, "Invalid ID");
        petSkills[_id].unlocked = true;
        emit PetSkillUnlocked(_id, msg.sender);
    }

    function getPetSkill(uint256 _id) public view returns (PetSkill memory) {
        require(_id < petSkills.length, "Invalid ID");
        return petSkills[_id];
    }

    function totalPetSkills() public view returns (uint256) {
        return petSkills.length;
    }
}
