// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TempestWraith {
    // [Goal: Make storms a mystical boss encounter]
    function encounterIntensity(uint256 _stormLevel) external pure returns (string memory) {
        if (_stormLevel > 80) {
            return "WARNING: The Storm Guardian has awakened. Nature is fighting back!";
        }
        return "WEATHER: Standard heavy rain.";
    }
}
