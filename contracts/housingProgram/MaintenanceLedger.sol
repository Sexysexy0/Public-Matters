// SPDX-License-Identifier: Mythic-License-2025
pragma solidity ^0.8.25;

contract MaintenanceLedger {
    address public steward;

    struct MaintenanceLog {
        string description;
        uint256 timestamp;
        address steward;
    }

    mapping(uint256 => MaintenanceLog[]) public unitLogs;

    event MaintenanceRecorded(uint256 unitId, string description, address steward, uint256 timestamp);

    constructor() {
        steward = msg.sender;
    }

    function recordMaintenance(uint256 unitId, string memory description) external {
        require(msg.sender == steward, "Only steward can record");
        unitLogs[unitId].push(MaintenanceLog(description, block.timestamp, msg.sender));
        emit MaintenanceRecorded(unitId, description, msg.sender, block.timestamp);
    }

    function getLogs(uint256 unitId) external view returns (MaintenanceLog[] memory) {
        return unitLogs[unitId];
    }
}
