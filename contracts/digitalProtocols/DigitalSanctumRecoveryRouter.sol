// SPDX-License-Identifier: SanctumRecovery
pragma solidity ^0.8.19;

contract DigitalSanctumRecoveryRouter {
    struct RecoverySignal {
        string deviceID;
        string infectionType;
        string recoveryMethod;
        bool restored;
        string stewardNote;
    }

    mapping(string => RecoverySignal) public recoveryRegistry;

    event DeviceTagged(string deviceID, string infectionType);
    event RecoveryExecuted(string deviceID);

    function tagDevice(string memory deviceID, string memory infectionType, string memory recoveryMethod, string memory stewardNote) public {
        recoveryRegistry[deviceID] = RecoverySignal(deviceID, infectionType, recoveryMethod, false, stewardNote);
        emit DeviceTagged(deviceID, infectionType);
    }

    function executeRecovery(string memory deviceID) public {
        require(bytes(recoveryRegistry[deviceID].infectionType).length > 0, "Device not tagged");
        recoveryRegistry[deviceID].restored = true;
        emit RecoveryExecuted(deviceID);
    }

    function getRecoveryStatus(string memory deviceID) public view returns (RecoverySignal memory) {
        return recoveryRegistry[deviceID];
    }
}
