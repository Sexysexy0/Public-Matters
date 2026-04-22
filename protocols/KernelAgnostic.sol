// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract KernelAgnostic {
    // [Goal: Create a base system that can host any gaming environment]
    function loadEnvironment(string memory _platform) external pure returns (string memory) {
        return string(abi.encodePacked("BOOTING: ", _platform, " subsystem on Linux Kernel."));
    }
}
