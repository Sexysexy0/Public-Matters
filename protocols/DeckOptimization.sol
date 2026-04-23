// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DeckOptimization {
    // [Goal: Maximize performance on Steam Deck and similar handhelds]
    function applyPowerProfile(bool _onBattery) external pure returns (string memory) {
        if (_onBattery) {
            return "BATTERY SAVER: Capping at 30fps with FSR Performance mode.";
        }
        return "DOCKED: Unlocking 60fps with FSR Quality mode.";
    }
}
