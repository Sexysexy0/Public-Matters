// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TransmogSystem {
    // [Goal: Aesthetic Excellence without sacrificing Power]
    function applySkin(string memory _stats, string memory _look) external pure returns (string memory) {
        return string(abi.encodePacked("TRANSMOG_ACTIVE: High stats from ", _stats, " with the cool look of ", _look));
    }
}

