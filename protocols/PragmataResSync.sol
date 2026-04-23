// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PragmataResSync {
    // [Goal: Harmonize resolution regardless of save file origin]
    function syncResolution(string memory _saveSource) external pure returns (string memory) {
        if (keccak256(abi.encodePacked(_saveSource)) == keccak256(abi.encodePacked("CrossGen"))) {
            return "SYNC: Legacy 1080p detected. Overriding to PS5 Native 1440p.";
        }
        return "STABLE: Native resolution active.";
    }
}
