// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DigitalFingerprint {
    // [Goal: Embed unique, traceable metadata into all pre-release materials]
    function tagUser(address _staff) external pure returns (bytes32) {
        return keccak256(abi.encodePacked("LEAK_TAG", _staff));
    }
}
