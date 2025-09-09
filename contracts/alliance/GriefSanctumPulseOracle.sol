// SPDX-License-Identifier: GriefPulse-License
pragma solidity ^0.8.0;

contract GriefSanctumPulseOracle {
    address public steward;

    struct Pulse {
        string zone;
        string sanctumType;
        string rippleEffect;
        uint256 timestamp;
    }

    Pulse[] public pulses;

    event GriefPulseEmitted(string zone, string sanctumType, string rippleEffect, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory zone, string memory sanctumType, string memory rippleEffect) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(Pulse(zone, sanctumType, rippleEffect, block.timestamp));
        emit GriefPulseEmitted(zone, sanctumType, rippleEffect, block.timestamp);
    }
}
