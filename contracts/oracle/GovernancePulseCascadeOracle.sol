// SPDX-License-Identifier: GovernancePulse-License
pragma solidity ^0.8.0;

contract GovernancePulseCascadeOracle {
    address public steward;

    struct Pulse {
        string reformType;
        string sanctum;
        uint256 harmonicLevel;
        uint256 timestamp;
    }

    Pulse[] public pulses;

    event GovernanceHarmonicEmitted(string reformType, string sanctum, uint256 harmonicLevel, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory reformType, string memory sanctum, uint256 harmonicLevel) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(Pulse(reformType, sanctum, harmonicLevel, block.timestamp));
        emit GovernanceHarmonicEmitted(reformType, sanctum, harmonicLevel, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, uint256, uint256) {
        Pulse memory p = pulses[index];
        return (p.reformType, p.sanctum, p.harmonicLevel, p.timestamp);
    }

    function totalPulses() public view returns (uint) {
        return pulses.length;
    }
}
