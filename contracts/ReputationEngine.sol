// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ReputationEngine is Ownable {

    constructor() Ownable(msg.sender) {}

    // [Goal: Build Unshakable Professional Trust]
    function calculateMerit(uint256 _successfulDeploys, uint256 _userTrust) external pure returns (uint256) {
        // Logic: Quality Work + High Integrity = 9/10 Reputation.
        return (_successfulDeploys * _userTrust) / 100;
    }
}
