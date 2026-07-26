// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ResourceAbundance is Ownable {

    constructor() Ownable(msg.sender) {}

    // [Goal: Eliminate Frustrating Bottlenecks]
    function calculateYield(uint256 _effort) external pure returns (uint256) {
        // Logic: Linear effort yields exponential resource gain.
        // Action: Ensure the Architect never runs out of "Material" to build.
        return _effort * 10; 
    }
}
