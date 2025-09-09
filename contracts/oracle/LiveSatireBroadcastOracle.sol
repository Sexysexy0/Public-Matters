// SPDX-License-Identifier: LiveSatire-License
pragma solidity ^0.8.0;

contract LiveSatireBroadcastOracle {
    address public steward;

    struct LivestreamPulse {
        string broadcaster;
        string segment;
        uint256 aprSpike;
        uint256 timestamp;
    }

    LivestreamPulse[] public pulses;

    event LivestreamHarmonicEmitted(string broadcaster, string segment, uint256 aprSpike, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitLivestreamPulse(string memory broadcaster, string memory segment, uint256 aprSpike) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(LivestreamPulse(broadcaster, segment, aprSpike, block.timestamp));
        emit LivestreamHarmonicEmitted(broadcaster, segment, aprSpike, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, uint256, uint256) {
        LivestreamPulse memory p = pulses[index];
        return (p.broadcaster, p.segment, p.aprSpike, p.timestamp);
    }

    function totalPulses() public view returns (uint) {
        return pulses.length;
    }
}
