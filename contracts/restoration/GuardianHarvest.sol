// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract GuardianHarvest {
    struct HarvestLog {
        string tribe;
        string resource; // e.g. "Rattan", "Banig", "Medicinal Bark"
        uint256 quantity;
        string permitStatus; // e.g. "Approved", "Pending", "Denied"
        string emotionalTag; // e.g. "AncestorGlow", "StopEnforce", "AuditGlow"
        uint256 timestamp;
    }

    HarvestLog[] public logs;

    event HarvestLogged(string tribe, string resource, uint256 quantity, string permitStatus, string emotionalTag);

    function logHarvest(
        string memory _tribe,
        string memory _resource,
        uint256 _quantity,
        string memory _permitStatus,
        string memory _emotionalTag
    ) public {
        logs.push(HarvestLog(_tribe, _resource, _quantity, _permitStatus, _emotionalTag, block.timestamp));
        emit HarvestLogged(_tribe, _resource, _quantity, _permitStatus, _emotionalTag);
    }

    function getLog(uint256 index) public view returns (HarvestLog memory) {
        return logs[index];
    }

    function totalLogs() public view returns (uint256) {
        return logs.length;
    }
}
