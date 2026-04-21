// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IslandProgression {
    mapping(address => uint256) public renown;

    // [Goal: Goal-Oriented Growth]
    function completeIsland(address _user, uint256 _renownGain) external {
        // Action: Increase status in the Malolos Lifeboat for every POI cleared.
        renown[_user] += _renownGain;
    }
}
