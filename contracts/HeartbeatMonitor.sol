// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract HeartbeatMonitor is Ownable {

    constructor() Ownable(msg.sender) {}

    uint256 public lastHeartbeat;

    // [Goal: Real-Time Integrity Check]
    function pulse() public {
        lastHeartbeat = block.timestamp;
    }

    function checkVitals() public view returns (string memory) {
        if (block.timestamp - lastHeartbeat > 1 hours) {
            return "ALERT: System Stagnant. Intervention Required.";
        }
        return "SYSTEM OPERATIONAL: Flow State Maintained.";
    }
}
