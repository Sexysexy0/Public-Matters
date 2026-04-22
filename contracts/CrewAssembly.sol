// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CrewAssembly {
    // [Goal: Zero-Downtime Mission Capability]
    function recruitMember(string memory _type) external pure returns (string memory) {
        // Logic: Accept 'Friend' for Multiplayer or 'NPC' for Solo-Plus.
        return string(abi.encodePacked("MEMBER_JOINED: ", _type, " is ready for the mission."));
    }
}
