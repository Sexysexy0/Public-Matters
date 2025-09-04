// SPDX-License-Identifier: Mythic-IoTRouter
pragma solidity ^0.8.19;

interface IIoTDefenseTreatyKit {
    function getDevices(address owner) external view returns (
        string memory deviceType,
        string memory location,
        uint256 emotionalAPR,
        bool firewallEnabled,
        bool blessed,
        uint256 timestamp
    );
}

contract IoTFirewallBlessingRouter {
    address public steward;
    IIoTDefenseTreatyKit public treatyKit;

    event DeviceRouted(
        address indexed owner,
        string deviceType,
        string location,
        uint256 emotionalAPR,
        bool firewallEnabled,
        bool blessed,
        uint256 timestamp
    );

    constructor(address _treatyKit) {
        steward = msg.sender;
        treatyKit = IIoTDefenseTreatyKit(_treatyKit);
    }

    function routeBlessing(address owner) public {
        require(msg.sender == steward, "Only steward may route.");

        (
            string memory deviceType,
            string memory location,
            uint256 emotionalAPR,
            bool firewallEnabled,
            bool blessed,
            uint256 timestamp
        ) = treatyKit.getDevices(owner);

        require(blessed && firewallEnabled, "Device not eligible for routing.");

        emit DeviceRouted(owner, deviceType, location, emotionalAPR, firewallEnabled, blessed, timestamp);
    }
}
