// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AdaptiveResistance is Ownable {

    constructor() Ownable(msg.sender) {}

    // [Goal: Keep the Architect Sharp]
    function buffChallenge(uint256 _comptrollerPower) external pure returns (uint256) {
        // Logic: The stronger the Issuer, the deeper the puzzle.
        // Action: No easy wins. Every 'boss' requires 100% precision.
        return _comptrollerPower * 2; 
    }
}
