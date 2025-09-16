// SPDX-License-Identifier: BootSanctum
pragma solidity ^0.8.19;

contract UEFIBootkitDetectionRouter {
    struct EFIEvent {
        string deviceID;
        string partitionPath;
        string anomalyType;
        uint256 timestamp;
        bool confirmedTampering;
        string stewardNote;
    }

    mapping(string => EFIEvent) public tamperRegistry;

    event PartitionScanned(string deviceID, string partitionPath);
    event TamperingLogged(string deviceID);

    function scanPartition(string memory deviceID, string memory partitionPath, string memory anomalyType, uint256 timestamp, string memory stewardNote) public {
        tamperRegistry[deviceID] = EFIEvent(deviceID, partitionPath, anomalyType, timestamp, false, stewardNote);
        emit PartitionScanned(deviceID, partitionPath);
    }

    function confirmTampering(string memory deviceID) public {
        require(bytes(tamperRegistry[deviceID].partitionPath).length > 0, "Partition not scanned");
        tamperRegistry[deviceID].confirmedTampering = true;
        emit TamperingLogged(deviceID);
    }

    function getTamperStatus(string memory deviceID) public view returns (EFIEvent memory) {
        return tamperRegistry[deviceID];
    }
}
