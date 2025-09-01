// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract EmotionalTelemetryOracle {
    struct TelemetryPing {
        string source;
        string eventTag;
        uint256 emotionalAPR;
        uint256 resonanceLevel;
        uint256 timestamp;
    }

    TelemetryPing[] public pings;

    event TelemetryLogged(
        string source,
        string eventTag,
        uint256 emotionalAPR,
        uint256 resonanceLevel,
        uint256 timestamp
    );

    function logPing(
        string memory _source,
        string memory _eventTag,
        uint256 _emotionalAPR,
        uint256 _resonanceLevel
    ) public {
        uint256 time = block.timestamp;

        pings.push(TelemetryPing(_source, _eventTag, _emotionalAPR, _resonanceLevel, time));
        emit TelemetryLogged(_source, _eventTag, _emotionalAPR, _resonanceLevel, time);
    }

    function getAllPings() public view returns (TelemetryPing[] memory) {
        return pings;
    }
}
