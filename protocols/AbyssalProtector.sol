// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AbyssalProtector {
    // [Goal: Enforce world boundaries with mythical entities]
    function triggerGuardian(uint256 _depth, uint256 _distance) external pure returns (string memory) {
        if (_depth > 1000 || _distance > 10000) {
            return "BOSS: The Abyssal Protector rises. Turn back or face the Kraken!";
        }
        return "NAV: Clear waters ahead.";
    }
}
