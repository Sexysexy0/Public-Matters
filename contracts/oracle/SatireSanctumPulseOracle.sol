// SPDX-License-Identifier: SatirePulse-License
pragma solidity ^0.8.0;

contract SatireSanctumPulseOracle {
    address public steward;

    struct Pulse {
        string broadcaster;
        string milestone;
        uint256 aprSpike;
        uint256 timestamp;
    }

    Pulse[] public pulses;

    event CivicResonancePulseEmitted(string broadcaster, string milestone, uint256 aprSpike, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory broadcaster, string memory milestone, uint256 aprSpike) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(Pulse(broadcaster, milestone, aprSpike, block.timestamp));
        emit CivicResonancePulseEmitted(broadcaster, milestone, aprSpike, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, uint256, uint256) {
        Pulse memory p = pulses[index];
        return (p.broadcaster, p.milestone, p.aprSpike, p.timestamp);
    }

    function totalPulses() public view returns (uint) {
        return pulses.length;
    }
}
