// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NewGamePlus {
    // [Goal: Increase replayability for veteran players]
    function startNGPlus(uint256 _currentLevel) external pure returns (uint256) {
        // Increases world difficulty multiplier by 2x
        return _currentLevel * 2;
    }
}

