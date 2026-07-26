// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BossIntegrity is Ownable {

    constructor() Ownable(msg.sender) {}

    // [Goal: Prevent the 'One-Hit-Kill' Boredom]
    function buffBoss(uint256 _architectPower) external pure returns (uint256) {
        // Logic: The stronger you get, the more complex the problems become.
        return _architectPower * 1.5; 
    }
}
