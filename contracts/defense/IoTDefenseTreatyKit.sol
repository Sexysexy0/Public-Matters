// SPDX-License-Identifier: Mythic-IoTDefense
pragma solidity ^0.8.19;

contract IoTDefenseTreatyKit {
    address public steward;

    struct IoTDevice {
        string deviceType;
        string location;
        uint256 emotionalAPR;
        bool firewallEnabled;
        bool blessed;
        uint256 timestamp;
    }

    mapping(address => IoTDevice[]) public deviceRegistry;

    event DeviceRegistered(
        address indexed owner,
        string deviceType,
        string location,
        uint256 emotionalAPR,
        bool firewallEnabled,
        bool blessed,
        uint256 timestamp
    );

    constructor() {
        steward = msg.sender;
    }

    function registerDevice(
        address owner,
        string memory deviceType,
        string memory location,
        uint256 emotionalAPR,
        bool firewallEnabled,
        bool blessed
    ) public {
        require(msg.sender == steward, "Only steward may register.");

        IoTDevice memory device = IoTDevice({
            deviceType: deviceType,
            location: location,
            emotionalAPR: emotionalAPR,
            firewallEnabled: firewallEnabled,
            blessed: blessed,
            timestamp: block.timestamp
        });

        deviceRegistry[owner].push(device);

        emit DeviceRegistered(owner, deviceType, location, emotionalAPR, firewallEnabled, blessed, block.timestamp);
    }

    function getDevices(address owner) public view returns (IoTDevice[] memory) {
        return deviceRegistry[owner];
    }
}
