// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title JackdawSovereignty
 * @dev Manages the Sovereign's flagship upgrades and crew loyalty.
 */
contract JackdawSovereignty {
    uint256 public firepower;

    // [Goal: Upgrade the primary vehicle of the Sovereign's mission (Career/Lifeboat)]
    function recruitCrew(string memory _name) external {
        firepower += 10; // [Every new ally increases the Sovereign's impact]
    }
}
