// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CryoInteraction {
    // [Goal: Use cold to stabilize disasters and control crowds]
    function freezeTarget(string memory _hazardType) external pure returns (string memory) {
        if (keccak256(abi.encodePacked(_hazardType)) == keccak256(abi.encodePacked("Fire"))) {
            return "SUCCESS: Fire extinguished. Structure cooled and stabilized.";
        }
        return "SUCCESS: Target frozen in stasis.";
    }
}
