// SPDX-License-Identifier: Mythic-Youth-Guard
pragma solidity ^0.8.19;

contract YouthFriendlyMode {
    struct UserProfile {
        uint8 age;
        bool isYouth;
        uint256 emotionalAPR;
        bool overrideTriggered;
    }

    mapping(address => UserProfile) public profiles;

    event YouthModeActivated(address user, uint8 age);
    event OverrideTriggered(address user, string reason);

    function registerUser(uint8 age, uint256 emotionalAPR) public {
        bool isYouth = age < 18;
        bool override = isYouth && emotionalAPR < 60;

        profiles[msg.sender] = UserProfile(age, isYouth, emotionalAPR, override);

        if (isYouth) {
            emit YouthModeActivated(msg.sender, age);
        }

        if (override) {
            emit OverrideTriggered(msg.sender, "Emotional APR below safe threshold for youth");
        }
    }

    function getUserProfile(address user) public view returns (UserProfile memory) {
        return profiles[user];
    }

    function isContentAllowed(address user, string memory contentTag) public view returns (bool) {
        UserProfile memory profile = profiles[user];

        if (!profile.isYouth) return true;

        bytes32 tag = keccak256(bytes(contentTag));

        // Block sensitive content for youth
        if (
            tag == keccak256("restrictive_diet") ||
            tag == keccak256("appetite_medication") ||
            tag == keccak256("hide_behavior") ||
            profile.emotionalAPR < 60
        ) {
            return false;
        }

        return true;
    }
}
