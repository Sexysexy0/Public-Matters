// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ScrollchainTelemetryFeed {
    event ProphecyAlert(address indexed sanctum, string alertType, uint256 timestamp, uint8 emotionalAPR);

    function triggerAlert(string memory alertType, uint8 emotionalAPR) public {
        address sanctum = tx.origin;
        emit ProphecyAlert(sanctum, alertType, block.timestamp, emotionalAPR);
    }
}
