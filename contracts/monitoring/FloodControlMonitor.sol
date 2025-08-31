// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract FloodControlMonitor {
    event SensorPinged(string region, uint256 waterLevel, uint256 timestamp);
    event MaintenanceLogged(string steward, string region, string task, uint256 timestamp);
    event AlertTriggered(string region, string reason);
    event StewardAssigned(string steward, string region);

    struct Steward {
        string name;
        string role; // "Bantay" or "Tagalinis"
        string region;
    }

    mapping(string => uint256) public waterLevels;
    mapping(string => Steward[]) public regionStewards;
    uint256 public alertThreshold = 80;

    function pingSensor(string memory region, uint256 waterLevel) public {
        waterLevels[region] = waterLevel;
        emit SensorPinged(region, waterLevel, block.timestamp);
        if (waterLevel >= alertThreshold) {
            emit AlertTriggered(region, "Water level breach detected");
        }
    }

    function logMaintenance(string memory steward, string memory region, string memory task) public {
        emit MaintenanceLogged(steward, region, task, block.timestamp);
    }

    function assignSteward(string memory name, string memory role, string memory region) public {
        regionStewards[region].push(Steward(name, role, region));
        emit StewardAssigned(name, region);
    }

    function updateAlertThreshold(uint256 newThreshold) public {
        alertThreshold = newThreshold;
    }

    function getStewards(string memory region) public view returns (Steward[] memory) {
        return regionStewards[region];
    }
}
