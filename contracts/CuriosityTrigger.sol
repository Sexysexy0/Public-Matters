// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CuriosityTrigger is Ownable {

    constructor() Ownable(msg.sender) {}

    // [Goal: Reward Wonder and Discovery]
    function rewardCuriosity(uint256 _crowdSize) external pure returns (string memory) {
        if (_crowdSize > 50) {
            return "MYSTERY_UNLOCKED: A traveler shares a legendary secret.";
        }
        return "COMMUNITY_BUILDING: Morale increased.";
    }
}
