// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LegacyQuestOverhaul {
    // [Goal: Turn 'Lame' tasks into 'Legendary' Milestones]
    function filterQuest(string memory _type) external pure returns (string memory) {
        if (keccak256(abi.encodePacked(_type)) == keccak256(abi.encodePacked("FetchQuest"))) {
            return "REJECTED: Too lame for the Architect.";
        }
        return "ACCEPTED: This quest builds the Lifeboat Legacy.";
    }
}
