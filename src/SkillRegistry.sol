// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SkillRegistry {
    struct SkillProfile {
        string name;
        string skillCategory; // e.g., "Software Engineering", "Hardware Repair", "Emergency Response"
        uint256 proficiencyLevel; // 1 to 10
        bool verified;
        bool active;
    }

    mapping(address => SkillProfile) public profiles;
    address public immutable registrySteward;

    event ProfileRegistered(address indexed user, string name, string skillCategory);
    event SkillVerified(address indexed user, bool status);
    event ProfileDeactivated(address indexed user);

    modifier onlySteward() {
        require(msg.sender == registrySteward, "Unauthorized: Steward only");
        _;
    }

    constructor() {
        registrySteward = msg.sender;
    }

    function registerSkill(
        string memory _name,
        string memory _skillCategory,
        uint256 _proficiencyLevel
    ) external {
        require(_proficiencyLevel >= 1 && _proficiencyLevel <= 10, "Proficiency must be between 1 and 10");
        
        profiles[msg.sender] = SkillProfile({
            name: _name,
            skillCategory: _skillCategory,
            proficiencyLevel: _proficiencyLevel,
            verified: false,
            active: true
        });

        emit ProfileRegistered(msg.sender, _name, _skillCategory);
    }

    function verifySkill(address _user, bool _status) external onlySteward {
        require(profiles[_user].active, "Profile is not active");
        profiles[_user].verified = _status;
        emit SkillVerified(_user, _status);
    }

    function deactivateProfile() external {
        require(profiles[msg.sender].active, "Profile already inactive");
        profiles[msg.sender].active = false;
        emit ProfileDeactivated(msg.sender);
    }

    function getProfile(address _user) external view returns (string memory, string memory, uint256, bool, bool) {
        SkillProfile memory p = profiles[_user];
        return (p.name, p.skillCategory, p.proficiencyLevel, p.verified, p.active);
    }
}
