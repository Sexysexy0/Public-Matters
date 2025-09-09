// SPDX-License-Identifier: ThreatPulse-License
pragma solidity ^0.8.0;

contract SanctumThreatPulseOracle {
    address public steward;

    struct ThreatPulse {
        string zone;
        string threatType;
        uint256 severityLevel;
        string triggerEvent;
        uint256 timestamp;
    }

    ThreatPulse[] public pulses;

    event ThreatPulseEmitted(string zone, string threatType, uint256 severity, string trigger, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory zone, string memory threatType, uint256 severityLevel, string memory triggerEvent) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(ThreatPulse(zone, threatType, severityLevel, triggerEvent, block.timestamp));
        emit ThreatPulseEmitted(zone, threatType, severityLevel, triggerEvent, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, uint256, string memory, uint256) {
        ThreatPulse memory p = pulses[index];
        return (p.zone, p.threatType, p.severityLevel, p.triggerEvent, p.timestamp);
    }

    function totalPulses() public view returns (uint) {
        return pulses.length;
    }
}
