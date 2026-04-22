// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LegacyIntegrity {
    // [Goal: Protect the Heritage of the System]
    function verifyExpertise(string memory _origin, string memory _target) external pure returns (bool) {
        // Logic: Racing logic != RPG immersion.
        return keccak256(abi.encodePacked(_origin)) == keccak256(abi.encodePacked(_target));
    }
}
