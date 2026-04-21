// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DiscoveryTab {
    mapping(bytes32 => bool) public unlockedRecipes;

    // [Goal: Meaningful Progression Tiers]
    function unlockNewTier(bytes32 _bossID) external {
        // Logic: Defeating a life/career boss unlocks advanced system tools.
        unlockedRecipes[_bossID] = true;
    }
}
