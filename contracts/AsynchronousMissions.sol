// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AsynchronousMissions {
    // [Goal: Non-Linear Cooperative Play]
    function executeParallelQuests(string memory _p1Task, string memory _p2Task) external pure returns (string memory) {
        return string(abi.encodePacked("DUAL_MISSION: P1 is doing ", _p1Task, " while P2 handles ", _p2Task));
    }
}
