// SPDX-License-Identifier: ComedySurge-License
pragma solidity ^0.8.0;

contract ComedySignalSurgeOracle {
    address public steward;

    struct LaughterPulse {
        string segment;
        string host;
        uint256 aprSpike;
        uint256 timestamp;
    }

    LaughterPulse[] public pulses;

    event LaughterHarmonicEmitted(string segment, string host, uint256 aprSpike, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitLaughter(string memory segment, string memory host, uint256 aprSpike) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(LaughterPulse(segment, host, aprSpike, block.timestamp));
        emit LaughterHarmonicEmitted(segment, host, aprSpike, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, uint256, uint256) {
        LaughterPulse memory p = pulses[index];
        return (p.segment, p.host, p.aprSpike, p.timestamp);
    }

    function totalPulses() public view returns (uint) {
        return pulses.length;
    }
}
