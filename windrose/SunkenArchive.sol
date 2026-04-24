// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SunkenArchive {
    // [Goal: Transform ruins into educational storytelling nodes]
    function readShipLog(string memory _shipName) external pure returns (string memory) {
        return string(abi.encodePacked("HISTORY_SYNC: Reliving the final moments of the ", _shipName));
    }
}
