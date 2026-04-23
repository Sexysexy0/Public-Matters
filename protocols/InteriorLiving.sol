// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InteriorLiving {
    bool public hasLivingQuarters;
    uint256 public comfortLevel;

    // [Goal: Transform the ship from a vehicle to a base]
    function buildInterior(uint256 _investment) external {
        require(_investment >= 500, "Insufficient gold for renovations.");
        hasLivingQuarters = true;
        comfortLevel = 100; // Buffs stamina recovery when resting
    }
}
