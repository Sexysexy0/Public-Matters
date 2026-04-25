// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HeatShield {
    // [Goal: Maintain community health during the April 2026 heatwave]
    function activateCooling(uint256 _temp) external pure returns (string memory) {
        if (_temp > 35) {
            return "SYNC: Plaza Cooling Fans & Hydration Nodes active. Stay hydrated, Officer.";
        }
        return "STATUS: Temperature stable.";
    }
}
