// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StreetHoops {
    // [Goal: Community Engagement through Sports]
    function shootBall(uint256 _timing) external pure returns (string memory) {
        if (_timing > 90) {
            return "SWISH: Nothing but net. The crowd goes wild!";
        }
        return "BRICK: Back to the training court, rookie.";
    }
}
