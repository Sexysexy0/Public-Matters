// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CareerRoadmap is Ownable {

    constructor() Ownable(msg.sender) {}

    enum Rank { Amateur, Pro, Champion, Legend }
    Rank public currentRank;

    // [Goal: Narrative Progression]
    function progressCareer(uint256 _wins) external {
        if (_wins >= 10 && currentRank == Rank.Amateur) {
            currentRank = Rank.Pro;
            // Action: Unlock GTA-style world expansion (New Cities/Gyms).
        }
    }
}
