// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract LicenseRevocationSuite {
    address public steward;
    mapping(string => bool) public regionAccess;

    event LicenseRevoked(string region);
    event LicenseGranted(string region);

    constructor() {
        steward = msg.sender;
        regionAccess["China"] = false;
        regionAccess["Russia"] = false;
        regionAccess["India"] = true;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    function revokeLicense(string memory region) public onlySteward {
        regionAccess[region] = false;
        emit LicenseRevoked(region);
    }

    function grantLicense(string memory region) public onlySteward {
        regionAccess[region] = true;
        emit LicenseGranted(region);
    }

    function checkAccess(string memory region) public view returns (bool) {
        return regionAccess[region];
    }
}
