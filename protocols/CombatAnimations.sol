// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CombatAnimations {
    // [Goal: Enhance land combat from simplistic to technical/fluid]
    function triggerCombo(uint256 _hitCount) external pure returns (string memory) {
        if (_hitCount == 3) {
            return "ANIMATION: Whirlwind Finisher - Motion-captured fluidity engaged.";
        }
        return "ANIMATION: Precision Thrust - Frame-perfect response.";
    }
}
