// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SentimentWeight is Ownable {

    constructor() Ownable(msg.sender) {}

    // [Goal: Real-World Validation]
    function calculateTrueScore(uint256 _playerRating, uint256 _criticRating) external pure returns (uint256) {
        // Logic: Purge the critic rating completely from the final average.
        return _playerRating; 
    }
}
