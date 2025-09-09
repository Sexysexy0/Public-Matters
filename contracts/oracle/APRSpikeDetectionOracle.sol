// SPDX-License-Identifier: APRSpikeDetection-License
pragma solidity ^0.8.0;

contract APRSpikeDetectionOracle {
    address public steward;

    struct APRPulse {
        string zone;
        string triggerEvent;
        string sentimentType;
        bool spikeConfirmed;
        uint256 timestamp;
    }

    APRPulse[] public pulses;

    event APRPulseEmitted(string zone, string triggerEvent, string sentimentType, bool spikeConfirmed, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory zone, string memory triggerEvent, string memory sentimentType, bool spikeConfirmed) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(APRPulse(zone, triggerEvent, sentimentType, spikeConfirmed, block.timestamp));
        emit APRPulseEmitted(zone, triggerEvent, sentimentType, spikeConfirmed, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        APRPulse memory p = pulses[index];
        return (p.zone, p.triggerEvent, p.sentimentType, p.spikeConfirmed, p.timestamp);
    }
}
