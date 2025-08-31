// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract SanctumNoiseProtocol {
    struct NoiseReport {
        string sanctumName;
        uint256 decibelLevel;
        string impactTag; // e.g., "Sleep Disruption", "Emotional Distress"
        string steward;
        uint256 timestamp;
    }

    NoiseReport[] public reports;

    event NoiseReported(string sanctumName, uint256 decibelLevel, string impactTag, string steward);

    function reportNoise(string memory sanctumName, uint256 decibel, string memory impactTag, string memory steward) public {
        reports.push(NoiseReport(sanctumName, decibel, impactTag, steward, block.timestamp));
        emit NoiseReported(sanctumName, decibel, impactTag, steward);
    }

    function getReport(uint index) public view returns (string memory, uint256, string memory, string memory, uint256) {
        NoiseReport memory r = reports[index];
        return (r.sanctumName, r.decibelLevel, r.impactTag, r.steward, r.timestamp);
    }
}
