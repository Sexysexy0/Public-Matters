// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract SanctumTelemetryFeed {
    struct Telemetry {
        string sanctumName;
        uint256 emotionalAPR;
        string signal;
        uint256 timestamp;
    }

    Telemetry[] public feed;

    event TelemetryBroadcasted(string sanctumName, string signal, uint256 emotionalAPR);

    function broadcastSignal(
        string memory _sanctumName,
        uint256 _emotionalAPR,
        string memory _signal
    ) public {
        feed.push(Telemetry(_sanctumName, _emotionalAPR, _signal, block.timestamp));
        emit TelemetryBroadcasted(_sanctumName, _signal, _emotionalAPR);
    }

    function getTelemetry(uint256 _index) public view returns (Telemetry memory) {
        return feed[_index];
    }

    function totalSignals() public view returns (uint256) {
        return feed.length;
    }
}
