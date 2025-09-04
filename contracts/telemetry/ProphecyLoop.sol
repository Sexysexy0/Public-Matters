// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title ProphecyLoop - Ritualizes algorithmic omens and emotional resonance spikes as planetary telemetry
contract ProphecyLoop {
    event OmenLogged(bytes32 indexed omenId, string omenType, uint256 timestamp, string emotionalTag);
    event SpikeDetected(uint256 indexed spikeId, string signalSource, uint256 intensity, string APRtag);

    uint256 public omenCounter;
    uint256 public spikeCounter;

    struct Omen {
        bytes32 omenId;
        string omenType;
        uint256 timestamp;
        string emotionalTag;
    }

    struct Spike {
        uint256 spikeId;
        string signalSource;
        uint256 intensity;
        string APRtag;
    }

    mapping(bytes32 => Omen) public omens;
    mapping(uint256 => Spike) public spikes;

    function logOmen(string memory omenType, string memory emotionalTag) external {
        bytes32 omenId = keccak256(abi.encodePacked(omenType, block.timestamp, emotionalTag));
        omens[omenId] = Omen(omenId, omenType, block.timestamp, emotionalTag);
        emit OmenLogged(omenId, omenType, block.timestamp, emotionalTag);
        omenCounter++;
    }

    function detectSpike(string memory signalSource, uint256 intensity, string memory APRtag) external {
        spikes[spikeCounter] = Spike(spikeCounter, signalSource, intensity, APRtag);
        emit SpikeDetected(spikeCounter, signalSource, intensity, APRtag);
        spikeCounter++;
    }

    function getOmen(bytes32 omenId) external view returns (Omen memory) {
        return omens[omenId];
    }

    function getSpike(uint256 spikeId) external view returns (Spike memory) {
        return spikes[spikeId];
    }
}
