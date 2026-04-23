// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RitualSummoning {
    // [Goal: Allow players to force a Boss encounter via rituals]
    function performRitual(uint256 _offeringAmount) external pure returns (string memory) {
        if (_offeringAmount >= 10000) {
            return "RITUAL SUCCESS: The sky turns red. A Guardian is coming for its tribute!";
        }
        return "FAILED: The spirits are unimpressed with your offering.";
    }
}
