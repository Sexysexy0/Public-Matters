// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GunshieldHybrid {
    // [Goal: Merge defensive protection with offensive output]
    function dualExecute(bool _isUnderAttack) external pure returns (string memory) {
        if (_isUnderAttack) return "SHIELD_UP: Absorbing impact while priming the counter-shot.";
        return "READY: High-fidelity offensive mode active.";
    }
}
