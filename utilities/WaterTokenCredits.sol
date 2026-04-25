// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract WaterTokenCredits {
    // [Goal: Equitable distribution of water resources during scarcity]
    mapping(address => uint256) public monthlyQuota;

    function consumeWater(address _user, uint256 _liters) external {
        require(monthlyQuota[_user] >= _liters, "INSUFFICIENT_CREDITS: Please conserve.");
        monthlyQuota[_user] -= _liters;
    }
}
