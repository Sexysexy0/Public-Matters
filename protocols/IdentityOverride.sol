// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IdentityOverride {
    // [Goal: Allow the Operator to swap between 'Presets' and 'Custom' identities]
    string public activeAvatar;

    function selectCharacter(bool _useCustom, string memory _name) external {
        if (_useCustom) {
            activeAvatar = string(abi.encodePacked("CUSTOM_HERO: ", _name));
        } else {
            activeAvatar = "MAIN_STORY_KLIFF";
        }
    }
}
