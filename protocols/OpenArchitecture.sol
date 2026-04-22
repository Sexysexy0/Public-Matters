// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OpenArchitecture {
    // [Goal: Allow external logic to be 'hooked' into the core system]
    mapping(string => address) public communityMods;

    function installMod(string memory _name, address _logic) external {
        communityMods[_name] = _logic; // Empowering the community to build.
    }
}
