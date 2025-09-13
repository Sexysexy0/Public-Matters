// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BlessingPulseRouter {
    enum PulseType { Elemental, Mythic, Civic, Null }
    enum BiomeType { Windy, Snowy, Rainy, Sandstorm, Hell, Starfall, Corruption, Null }

    struct PulseBlessing {
        uint256 id;
        PulseType pulseType;
        BiomeType biomeType;
        string artifactTag;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => PulseBlessing) public pulseRegistry;
    uint256 public pulseCount;

    event PulseLogged(uint256 id, PulseType pulseType, BiomeType biomeType);
    event BiomeUpdated(uint256 id, BiomeType newBiomeType);

    function logPulse(
        PulseType pulseType,
        BiomeType biomeType,
        string memory artifactTag,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        pulseRegistry[pulseCount] = PulseBlessing(
            pulseCount,
            pulseType,
            biomeType,
            artifactTag,
            clauseReference,
            timestamp
        );
        emit PulseLogged(pulseCount, pulseType, biomeType);
        pulseCount++;
    }

    function updateBiome(uint256 id, BiomeType newBiomeType) public {
        require(id < pulseCount, "Invalid pulse ID");
        pulseRegistry[id].biomeType = newBiomeType;
        emit BiomeUpdated(id, newBiomeType);
    }

    function getPulseBlessing(uint256 id) public view returns (PulseBlessing memory) {
        return pulseRegistry[id];
    }
}
