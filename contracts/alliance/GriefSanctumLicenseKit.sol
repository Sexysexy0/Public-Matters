// SPDX-License-Identifier: GriefSanctum-License
pragma solidity ^0.8.0;

contract GriefSanctumLicenseKit {
    address public steward;

    struct SanctumLicense {
        string beneficiary;
        string sanctumZone;
        string griefSupportType;
        bool verified;
        uint256 timestamp;
    }

    SanctumLicense[] public licenses;

    event SanctumLicenseIssued(string beneficiary, string zone, string supportType, bool verified, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function issueLicense(string memory beneficiary, string memory sanctumZone, string memory griefSupportType, bool verified) public {
        require(msg.sender == steward, "Only steward can issue");
        licenses.push(SanctumLicense(beneficiary, sanctumZone, griefSupportType, verified, block.timestamp));
        emit SanctumLicenseIssued(beneficiary, sanctumZone, griefSupportType, verified, block.timestamp);
    }

    function getLicense(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        SanctumLicense memory l = licenses[index];
        return (l.beneficiary, l.sanctumZone, l.griefSupportType, l.verified, l.timestamp);
    }
}
