// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AvianCompanion {
    // [Goal: Manage pet ownership and companion perks]
    function purchasePet(uint256 _gold) external pure returns (string memory) {
        require(_gold >= 1000, "Insufficient gold for a trained Parrot.");
        return "SUCCESS: Parrot added to your shoulder. Scouting buff active.";
    }
}
