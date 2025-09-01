// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract FiscalTelemetrySuite {
    struct FiscalEvent {
        string steward;
        string eventType;
        uint256 amount;
        string emotionalTag;
        uint256 timestamp;
    }

    FiscalEvent[] public telemetryLog;

    event FiscalLogged(string steward, string eventType, uint256 amount, string emotionalTag);

    function logFiscalEvent(
        string memory _steward,
        string memory _eventType,
        uint256 _amount,
        string memory _emotionalTag
    ) public {
        telemetryLog.push(FiscalEvent(_steward, _eventType, _amount, _emotionalTag, block.timestamp));
        emit FiscalLogged(_steward, _eventType, _amount, _emotionalTag);
    }

    function getTelemetryLog() public view returns (FiscalEvent[] memory) {
        return telemetryLog;
    }
}
