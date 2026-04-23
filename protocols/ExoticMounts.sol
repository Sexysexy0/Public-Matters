// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ExoticMounts {
    // [Goal: Grant unique abilities to elite feline mounts]
    function mountAbility(string memory _species) external pure returns (string memory) {
        if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("Panther"))) {
            return "STEALTH: Movement noise reduced by 80% in jungles.";
        }
        if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("Lion"))) {
            return "ROAR: Nearby enemies are stunned for 3 seconds.";
        }
        return "STABLE: Standard predator mount.";
    }
}
