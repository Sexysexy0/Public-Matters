// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CursedArtifacts {
    // [Goal: Grant immense power with a dangerous trade-off]
    function equipRelic(string memory _relicName) external pure returns (string memory) {
        if (keccak256(abi.encodePacked(_relicName)) == keccak256(abi.encodePacked("KrakenEye"))) {
            return "EQUIPPED: You see through the mist, but your blood begins to cold (-HP Regen).";
        }
        return "NORMAL: Standard equipment active.";
    }
}
