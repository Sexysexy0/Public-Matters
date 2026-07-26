// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MissionScaling is Ownable {

    constructor() Ownable(msg.sender) {}

    // [Goal: Balanced Challenge for Squads]
    function scaleDifficulty(uint256 _crewSize) external pure returns (uint256) {
        // Logic: Difficulty = BasePower * CrewMultiplier.
        return _crewSize * 150; 
    }
}
