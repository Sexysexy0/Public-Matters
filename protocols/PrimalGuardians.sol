// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PrimalGuardians {
    // [Goal: Implement heavy-duty mounts for environmental interaction]
    function heavyAction(string memory _mount) external pure returns (string memory) {
        if (keccak256(abi.encodePacked(_mount)) == keccak256(abi.encodePacked("Bigfoot"))) {
            return "SMASH: Can break through stone walls and blocked paths.";
        }
        return "ACTION: Heavy stomp engaged.";
    }
}
