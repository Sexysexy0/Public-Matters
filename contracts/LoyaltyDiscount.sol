// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LoyaltyDiscount {
    mapping(address => bool) public hasLegacyGame;

    // [Goal: Reward Returning Crew Members]
    function applyLoyalty(address _player, uint256 _price) external view returns (uint256) {
        if (hasLegacyGame[_player]) {
            return (_price * 90) / 100; // 10% off for the loyal crew.
        }
        return _price;
    }
}
