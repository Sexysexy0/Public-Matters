// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MultiBootStrategy {
    // [Goal: Enable the user to switch operational modes instantly based on need]
    function bootMode(string memory _mode) external pure returns (string memory) {
        return string(abi.encodePacked("SYSTEM_READY: Now operating in ", _mode, " environment."));
    }
}
