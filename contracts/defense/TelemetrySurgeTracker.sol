// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TelemetrySurgeTracker {
    struct SurgeEvent {
        string source;
        string category;
        uint256 emotionalAPR;
        uint256 civicResonance;
        uint256 timestamp;
        bool isAnomalous;
    }

    SurgeEvent[] public surgeEvents;

    event SurgeLogged(
        string source,
        string category,
        uint256 emotionalAPR,
        uint256 civicResonance,
        uint256 timestamp,
        bool isAnomalous
    );

    function logSurge(
        string memory _source,
        string memory _category,
        uint256 _emotionalAPR,
        uint256 _civicResonance
    ) public {
        bool anomaly = (_emotionalAPR > 90 || _civicResonance > 85);
        uint256 time = block.timestamp;

        surgeEvents.push(SurgeEvent(_source, _category, _emotionalAPR, _civicResonance, time, anomaly));
        emit SurgeLogged(_source, _category, _emotionalAPR, _civicResonance, time, anomaly);
    }

    function getAllSurges() public view returns (SurgeEvent[] memory) {
        return surgeEvents;
    }

    function getAnomalies() public view returns (SurgeEvent[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < surgeEvents.length; i++) {
            if (surgeEvents[i].isAnomalous) {
                count++;
            }
        }

        SurgeEvent[] memory anomalies = new SurgeEvent[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < surgeEvents.length; i++) {
            if (surgeEvents[i].isAnomalous) {
                anomalies[index] = surgeEvents[i];
                index++;
            }
        }

        return anomalies;
    }
}
