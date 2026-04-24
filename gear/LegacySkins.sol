// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LegacySkins {
    // [Goal: Bridge the generations via iconic visual symbols]
    function applySkin(string memory _legacyName) external pure returns (string memory) {
        return string(abi.encodePacked("RESYNC_COMPLETE: Appearance set to ", _legacyName));
    }
}
