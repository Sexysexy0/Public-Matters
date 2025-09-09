// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainHardwareSanctumQuarantineProtocol {
    address public steward;
    mapping(string => bool) public quarantinedDevices;

    event DeviceQuarantined(string device, string reason, uint timestamp);

    function quarantineDevice(string memory device, string memory reason) public {
        quarantinedDevices[device] = true;
        emit DeviceQuarantined(device, reason, block.timestamp);
    }

    function isQuarantined(string memory device) public view returns (bool) {
        return quarantinedDevices[device];
    }
}
