// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract GreedIndexTelemetry {
    uint256 public fearGreedIndex;
    string public marketMood;

    event MoodTagged(uint256 index, string mood);

    function tagMood(uint256 _index) public {
        fearGreedIndex = _index;
        marketMood = _index < 30 ? "Fear" : _index > 70 ? "Greed" : "Neutral";
        emit MoodTagged(_index, marketMood);
    }
}
