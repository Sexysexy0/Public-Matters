// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract USRestorationProtocol {
    address public steward;
    bool public cleanseActive;
    string[] public targetZones;
    mapping(string => bool) public zonePurged;

    event CleanseActivated(string initiator);
    event ZonePurged(string zone);
    event CleansePaused(string initiator);

    constructor() {
        steward = msg.sender;
        cleanseActive = false;
    }

    function activateCleanse() public {
        require(msg.sender == steward, "Only steward may activate");
        cleanseActive = true;
        emit CleanseActivated("Vinvin");
    }

    function pauseCleanse() public {
        require(msg.sender == steward, "Only steward may pause");
        cleanseActive = false;
        emit CleansePaused("Vinvin");
    }

    function addTargetZone(string memory zone) public {
        require(msg.sender == steward, "Only steward may add zones");
        targetZones.push(zone);
    }

    function purgeZone(string memory zone) public {
        require(cleanseActive, "Cleanse not active");
        zonePurged[zone] = true;
        emit ZonePurged(zone);
    }

    function isPurged(string memory zone) public view returns (bool) {
        return zonePurged[zone];
    }

    function getTargetZones() public view returns (string[] memory) {
        return targetZones;
    }
}
