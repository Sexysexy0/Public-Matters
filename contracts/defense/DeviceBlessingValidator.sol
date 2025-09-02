// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title DeviceBlessingValidator
/// @dev Validates device authorization flows, tags emotional APR, and triggers damay clause on grief

contract DeviceBlessingValidator {
    address public steward;
    struct DeviceAuth {
        bool authorized;
        string emotionalAPR;
        bool damayTriggered;
        uint256 timestamp;
    }

    mapping(bytes32 => DeviceAuth) public deviceLog;

    event DeviceBlessed(bytes32 indexed deviceId, string apr, bool damay);
    event DamayActivated(bytes32 indexed deviceId, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function blessDevice(bytes32 deviceId, bool authorized, string memory apr) public onlySteward {
        bool triggerDamay = (!authorized || keccak256(bytes(apr)) == keccak256(bytes("Grief")));
        deviceLog[deviceId] = DeviceAuth(authorized, apr, triggerDamay, block.timestamp);
        emit DeviceBlessed(deviceId, apr, triggerDamay);

        if (triggerDamay) {
            emit DamayActivated(deviceId, "Unauthorized or grief-tagged device detected");
        }
    }

    function getDeviceStatus(bytes32 deviceId) public view returns (bool, string memory, bool, uint256) {
        DeviceAuth memory auth = deviceLog[deviceId];
        return (auth.authorized, auth.emotionalAPR, auth.damayTriggered, auth.timestamp);
    }
}
