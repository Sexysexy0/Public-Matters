// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CrewSynergy {
    // [Goal: Harmonize different skillsets into one unstoppable force]
    function assignRole(address _member, string memory _role) external pure returns (string memory) {
        return string(abi.encodePacked("ASSIGNED: ", _role, " role locked for crew member."));
    }
}
