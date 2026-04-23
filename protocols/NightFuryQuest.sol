// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NightFuryQuest {
    // [Goal: Manage the legendary quest for the Night Fury mount]
    function startDragonQuest(bool _foundCastle, bool _foundCave) external pure returns (string memory) {
        if (_foundCastle && _foundCave) {
            return "SUCCESS: You've tamed the Night Fury. The sky is yours, Dragon Rider!";
        }
        return "QUEST: Seek the Hidden Dragon in the Cave beyond the Sky Castle.";
    }
}
