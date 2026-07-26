// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract FarmingEmpire is Ownable {

    constructor() Ownable(msg.sender) {}

    // [Goal: Transition from Mercenary to Landowner]
    function harvestResources(uint256 _landSize) external pure returns (uint256) {
        // Logic: More land + more workers = higher resource output.
        return _landSize * 50; 
    }
}
