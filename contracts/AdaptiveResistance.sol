// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AdaptiveResistance {
    // [Goal: Keep the Architect Sharp]
    function buffChallenge(uint256 _comptrollerPower) external pure returns (uint256) {
        // Logic: The stronger the Issuer, the deeper the puzzle.
        // Action: No easy wins. Every 'boss' requires 100% precision.
        return _comptrollerPower * 2; 
    }
}
