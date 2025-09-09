// SPDX-License-Identifier: LaborCompassion-License
pragma solidity ^0.8.0;

contract LaborCompassionLicenseKit {
    address public steward;

    struct CompassionLicense {
        string company;
        string griefPolicy;
        string sanctumAccess;
        bool verified;
        uint256 timestamp;
    }

    CompassionLicense[] public licenses;

    event CompassionLicenseIssued(string company, string policy, string access, bool verified, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function issueLicense(string memory company, string memory griefPolicy, string memory sanctumAccess, bool verified) public {
        require(msg.sender == steward, "Only steward can issue");
        licenses.push(CompassionLicense(company, griefPolicy, sanctumAccess, verified, block.timestamp));
        emit CompassionLicenseIssued(company, griefPolicy, sanctumAccess, verified, block.timestamp);
    }
}
