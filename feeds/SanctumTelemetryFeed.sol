// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Sanctum Telemetry Feed
/// @notice Emits emotional resonance and override signals for planetary sync
contract SanctumTelemetryFeed {
    event EmotionalSpike(string regionCode, uint256 APR, string sentiment);
    event OverrideSignal(string regionCode, uint256 blessingLevel, string signalTag);

    mapping(string => uint256) public emotionalAPR;
    mapping(string => string) public lastSignalTag;

    function emitEmotionalSpike(string memory regionCode, uint256 APR, string memory sentiment) external {
        emotionalAPR[regionCode] = APR;
        emit EmotionalSpike(regionCode, APR, sentiment);
    }

    function broadcastOverrideSignal(string memory regionCode, uint256 blessingLevel, string memory signalTag) external {
        lastSignalTag[regionCode] = signalTag;
        emit OverrideSignal(regionCode, blessingLevel, signalTag);
    }

    function getTelemetry(string memory regionCode) external view returns (uint256 APR, string memory tag) {
        return (emotionalAPR[regionCode], lastSignalTag[regionCode]);
    }
}
