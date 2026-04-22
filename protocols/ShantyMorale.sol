// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ShantyMorale {
    // [Goal: Boost team spirit and maintain psychological 'Frame Rate']
    function playShanty(string memory _songName) external pure returns (string memory) {
        return string(abi.encodePacked("SINGING: '", _songName, "' - Morale increased by 100%!"));
    }
}
