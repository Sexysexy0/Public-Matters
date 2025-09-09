// SPDX-License-Identifier: LatencyCascade-License
pragma solidity ^0.8.0;

contract SanctumLatencyCascadeOracle {
    address public steward;

    struct LatencyPulse {
        string sanctum;
        uint256 latencyMs;
        string triggerType;
        uint256 timestamp;
    }

    LatencyPulse[] public pulses;

    event LatencyHarmonicEmitted(string sanctum, uint256 latencyMs, string triggerType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitLatencyPulse(string memory sanctum, uint256 latencyMs, string memory triggerType) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(LatencyPulse(sanctum, latencyMs, triggerType, block.timestamp));
        emit LatencyHarmonicEmitted(sanctum, latencyMs, triggerType, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, uint256, string memory, uint256) {
        LatencyPulse memory p = pulses[index];
        return (p.sanctum, p.latencyMs, p.triggerType, p.timestamp);
    }

    function totalPulses() public view returns (uint) {
        return pulses.length;
    }
}
