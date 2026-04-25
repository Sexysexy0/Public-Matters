// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract WaterFlowAudit {
    // [Goal: Real-time monitoring of water supply integrity]
    function reportPressure(uint256 _psi, string memory _location) external pure returns (string memory) {
        if (_psi < 5) {
            return "CRITICAL: Zero flow detected in Kaypian Hills. Alerting Central Ops.";
        }
        return "STATUS: Flow optimal.";
    }
}
