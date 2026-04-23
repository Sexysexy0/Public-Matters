// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NightGuardians {
    // [Goal: Increase danger levels during night cycles]
    function spawnNightStalkers(uint256 _hour, bool _hasLantern) external pure returns (string memory) {
        if (_hour >= 22 || _hour <= 4) {
            if (!_hasLantern) return "DANGER: Ghost Ships emerging from the mist!";
            return "CAUTION: Shadows are watching from the waves.";
        }
        return "SAFE: The sun protects the seas.";
    }
}
