// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TelemetryOracle {
    address public steward;
    mapping(string => uint256) public emotionalAPR;
    mapping(string => string) public telemetrySignal;

    event TelemetrySynced(string tag, uint256 apr, string signal);

    constructor() {
        steward = msg.sender;
    }

    function syncTelemetry(string memory tag, uint256 apr, string memory signal) public {
        require(msg.sender == steward, "Only steward may sync");
        emotionalAPR[tag] = apr;
        telemetrySignal[tag] = signal;
        emit TelemetrySynced(tag, apr, signal);
    }

    function getAPR(string memory tag) public view returns (uint256) {
        return emotionalAPR[tag];
    }

    function getSignal(string memory tag) public view returns (string memory) {
        return telemetrySignal[tag];
    }
}
