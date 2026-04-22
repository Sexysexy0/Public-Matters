// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UnifiedCommand {
    // [Goal: Control the Fleet without leaving the Mission]
    function sendPing(string memory _unit, string memory _task) external pure returns (string memory) {
        return string(abi.encodePacked("COMMAND_SENT: ", _unit, " is executing ", _task, " remotely."));
    }
}
