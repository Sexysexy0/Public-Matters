// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DynamicWeatherMesh {
    // [Goal: Link visual weather systems to in-game economic rewards]
    function applyStormMultiplier(uint256 _waveHeight) external pure returns (uint256) {
        if (_waveHeight > 10) return 2; // 2x Loot during Typhoons
        return 1;
    }
}
