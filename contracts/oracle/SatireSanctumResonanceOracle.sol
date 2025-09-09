// SPDX-License-Identifier: SatireResonance-License
pragma solidity ^0.8.0;

contract SatireSanctumResonanceOracle {
    address public steward;

    struct Resonance {
        string segment;
        uint256 aprSpike;
        string host;
        uint256 timestamp;
    }

    Resonance[] public pulses;

    event SatireHarmonicEmitted(string segment, uint256 aprSpike, string host, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitResonance(string memory segment, uint256 aprSpike, string memory host) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(Resonance(segment, aprSpike, host, block.timestamp));
        emit SatireHarmonicEmitted(segment, aprSpike, host, block.timestamp);
    }

    function getResonance(uint index) public view returns (string memory, uint256, string memory, uint256) {
        Resonance memory r = pulses[index];
        return (r.segment, r.aprSpike, r.host, r.timestamp);
    }

    function totalResonances() public view returns (uint) {
        return pulses.length;
    }
}
