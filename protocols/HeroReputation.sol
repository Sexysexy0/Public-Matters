// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HeroReputation {
    // [Goal: Track the impact of the hero's actions on society]
    uint256 public publicTrust = 75;

    function adjustTrust(int256 _change) external {
        int256 newTrust = int256(publicTrust) + _change;
        publicTrust = uint256(newTrust);
    }
}
