// SkillValidationLedger.sol
pragma solidity ^0.8.0;

contract SkillValidationLedger {
    struct ProfessionalProfile {
        string skillName;
        uint256 proficiencyLevel; // 1-100
        address certifier;        // Authorized Training Center
        uint256 dateAcquired;
    }

    mapping(address => ProfessionalProfile[]) public workerSkills;

    function addSkill(address _worker, string memory _skill, uint256 _level) public {
        // Only authorized vocational schools can call this
        workerSkills[_worker].push(ProfessionalProfile(_skill, _level, msg.sender, block.timestamp));
    }
}
