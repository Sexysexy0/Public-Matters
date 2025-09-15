// SPDX-License-Identifier: BYOVDSanctum
pragma solidity ^0.8.19;

contract BYOVDQuarantineRouter {
    struct DriverSignal {
        string driverName;
        string fileHash;
        string cveTag;
        uint256 threatScore;
        bool quarantineTriggered;
        string stewardNote;
    }

    mapping(string => DriverSignal) public signals;

    event DriverTagged(string driverName, string cveTag);
    event QuarantineActivated(string driverName);

    function tagDriver(string memory driverName, string memory fileHash, string memory cveTag, uint256 threatScore, string memory stewardNote) public {
        signals[driverName] = DriverSignal(driverName, fileHash, cveTag, threatScore, false, stewardNote);
        emit DriverTagged(driverName, cveTag);
    }

    function activateQuarantine(string memory driverName) public {
        require(signals[driverName].threatScore >= 85, "Threat not critical");
        signals[driverName].quarantineTriggered = true;
        emit QuarantineActivated(driverName);
    }

    function getDriverStatus(string memory driverName) public view returns (DriverSignal memory) {
        return signals[driverName];
    }
}
