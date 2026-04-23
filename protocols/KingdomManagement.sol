// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract KingdomManagement {
    // [Goal: Transition player from a wanderer to a Ruler]
    function upgradeToKingdom(uint256 _fameLevel) external pure returns (string memory) {
        if (_fameLevel > 1000) {
            return "ASCENSION: You are now the Lord of this territory. Build your castle!";
        }
        return "QUEST: Gain more fame to claim your throne.";
    }
}
