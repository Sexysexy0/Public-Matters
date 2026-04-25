// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract WaveHarvesting {
    // [Goal: Convert maritime kinetic energy into local grid power]
    function captureEnergy(uint256 _waveHeight, uint256 _frequency) external pure returns (uint256) {
        return _waveHeight * _frequency; // Power Output in KWh
    }
}
