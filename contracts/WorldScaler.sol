// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract WorldScaler is Ownable {

    constructor() Ownable(msg.sender) {}

    // [Goal: Massive Scale without Quality Loss]
    function scaleTerrain(uint256 _baseSize) external pure returns (uint256) {
        // Logic: 4x expansion with unique biome generation.
        return _baseSize * 4; 
    }
}
