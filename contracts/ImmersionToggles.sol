// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ImmersionToggles is Ownable {

    constructor() Ownable(msg.sender) {}

    bool public hideBackWeapons;

    // [Goal: Enhance Visual Immersion]
    function toggleWeaponVisibility() external {
        hideBackWeapons = !hideBackWeapons;
        // Result: Cleaner character model for "Chunky Cat" screenshots.
    }
}
