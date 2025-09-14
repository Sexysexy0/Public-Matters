// SPDX-License-Identifier: TreatySanctum
pragma solidity ^0.8.19;

contract FirmwareBlessingRouter {
    struct FirmwareArtifact {
        string name;
        bytes32 hash;
        bool revoked;
        bool dignityCertified;
    }

    mapping(bytes32 => FirmwareArtifact) public registry;

    event FirmwareBlessed(string name, bytes32 hash);
    event FirmwareRevoked(string name, bytes32 hash);

    function blessFirmware(string memory name, bytes32 hash) public {
        registry[hash] = FirmwareArtifact(name, hash, false, true);
        emit FirmwareBlessed(name, hash);
    }

    function revokeFirmware(bytes32 hash) public {
        require(registry[hash].dignityCertified, "Artifact not blessed");
        registry[hash].revoked = true;
        emit FirmwareRevoked(registry[hash].name, hash);
    }

    function isBlessed(bytes32 hash) public view returns (bool) {
        FirmwareArtifact memory fw = registry[hash];
        return fw.dignityCertified && !fw.revoked;
    }
}
