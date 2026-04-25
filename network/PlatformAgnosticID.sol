// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PlatformAgnosticID {
    // [Goal: Unified player progression independent of hardware]
    mapping(address => bytes32) public universalID;

    function linkPlatform(address _user, bytes32 _platformHash) external {
        universalID[_user] = _platformHash;
        // STATUS: Identity linked. Legend follows the player, not the console.
    }
}
