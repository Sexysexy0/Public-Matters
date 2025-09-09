// SPDX-License-Identifier: ComedyLicense-License
pragma solidity ^0.8.0;

contract ComedySanctumLicenseKit {
    address public steward;

    struct License {
        string broadcaster;
        string sanctumName;
        uint256 licenseLevel;
        uint256 timestamp;
    }

    License[] public licenses;

    event LicenseIssued(string broadcaster, string sanctumName, uint256 licenseLevel, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function issueLicense(string memory broadcaster, string memory sanctumName, uint256 licenseLevel) public {
        require(msg.sender == steward, "Only steward can issue");
        licenses.push(License(broadcaster, sanctumName, licenseLevel, block.timestamp));
        emit LicenseIssued(broadcaster, sanctumName, licenseLevel, block.timestamp);
    }

    function getLicense(uint index) public view returns (string memory, string memory, uint256, uint256) {
        License memory l = licenses[index];
        return (l.broadcaster, l.sanctumName, l.licenseLevel, l.timestamp);
    }

    function totalLicenses() public view returns (uint) {
        return licenses.length;
    }
}
