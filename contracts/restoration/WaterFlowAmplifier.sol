// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract WaterFlowAmplifier {
    struct BarangayWaterStatus {
        string barangay;
        string locationTag; // e.g. "Zone 3", "Sitio Riverside"
        bool hasLowPressure;
        bool hasNoAccess;
        bool tankDeployed;
        uint256 tankCapacityLiters;
        string emotionalTag; // e.g. "BlessedFlow", "DamayClause", "HydrationGlow"
        uint256 timestamp;
    }

    BarangayWaterStatus[] public waterLogs;

    event WaterTankLogged(string barangay, bool hasLowPressure, bool hasNoAccess, bool tankDeployed, uint256 tankCapacityLiters, string emotionalTag);

    function logWaterStatus(
        string memory _barangay,
        string memory _locationTag,
        bool _hasLowPressure,
        bool _hasNoAccess,
        bool _tankDeployed,
        uint256 _tankCapacityLiters,
        string memory _emotionalTag
    ) public {
        waterLogs.push(BarangayWaterStatus(_barangay, _locationTag, _hasLowPressure, _hasNoAccess, _tankDeployed, _tankCapacityLiters, _emotionalTag, block.timestamp));
        emit WaterTankLogged(_barangay, _hasLowPressure, _hasNoAccess, _tankDeployed, _tankCapacityLiters, _emotionalTag);
    }

    function getWaterLog(uint256 index) public view returns (BarangayWaterStatus memory) {
        return waterLogs[index];
    }

    function totalLogs() public view returns (uint256) {
        return waterLogs.length;
    }
}
