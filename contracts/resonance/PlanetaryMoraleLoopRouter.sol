// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PlanetaryMoraleLoopRouter {
    struct MoraleSignal {
        string region;
        string sourceEvent;
        int256 aprSurgeLevel;
        uint256 timestamp;
        string resonanceTag;
    }

    mapping(uint256 => MoraleSignal) public moraleLedger;
    uint256 public signalCount;

    event MoraleSurgeLogged(uint256 id, string region, string resonanceTag);

    function logMoraleSurge(
        string memory region,
        string memory sourceEvent,
        int256 aprSurgeLevel,
        uint256 timestamp,
        string memory resonanceTag
    ) public {
        moraleLedger[signalCount] = MoraleSignal(
            region,
            sourceEvent,
            aprSurgeLevel,
            timestamp,
            resonanceTag
        );
        emit MoraleSurgeLogged(signalCount, region, resonanceTag);
        signalCount++;
    }

    function getMoraleSignal(uint256 id) public view returns (MoraleSignal memory) {
        return moraleLedger[id];
    }
}
