// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AssetTelemetry {
    struct Telemetry {
        string assetID;
        uint256 emotionalAPR;
        uint256 auditScore;
        string timestamp;
        string broadcastTag;
    }

    Telemetry[] public telemetryLogs;

    event TelemetryLogged(string assetID, uint256 emotionalAPR, uint256 auditScore, string broadcastTag);

    function logTelemetry(
        string memory _assetID,
        uint256 _emotionalAPR,
        uint256 _auditScore,
        string memory _timestamp,
        string memory _broadcastTag
    ) public {
        telemetryLogs.push(Telemetry({
            assetID: _assetID,
            emotionalAPR: _emotionalAPR,
            auditScore: _auditScore,
            timestamp: _timestamp,
            broadcastTag: _broadcastTag
        }));

        emit TelemetryLogged(_assetID, _emotionalAPR, _auditScore, _broadcastTag);
    }

    function getTelemetryCount() public view returns (uint256) {
        return telemetryLogs.length;
    }
}
