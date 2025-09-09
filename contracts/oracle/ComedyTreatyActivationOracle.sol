// SPDX-License-Identifier: ComedyTreaty-License
pragma solidity ^0.8.0;

contract ComedyTreatyActivationOracle {
    address public steward;

    struct ReformPulse {
        string segment;
        string civicTheme;
        uint256 aprSpike;
        uint256 timestamp;
    }

    ReformPulse[] public pulses;

    event CivicSatireHarmonicEmitted(string segment, string civicTheme, uint256 aprSpike, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitReformPulse(string memory segment, string memory civicTheme, uint256 aprSpike) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(ReformPulse(segment, civicTheme, aprSpike, block.timestamp));
        emit CivicSatireHarmonicEmitted(segment, civicTheme, aprSpike, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, uint256, uint256) {
        ReformPulse memory p = pulses[index];
        return (p.segment, p.civicTheme, p.aprSpike, p.timestamp);
    }

    function totalPulses() public view returns (uint) {
        return pulses.length;
    }
}
