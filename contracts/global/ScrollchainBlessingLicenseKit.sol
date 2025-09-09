// SPDX-License-Identifier: BlessingLicense-License
pragma solidity ^0.8.0;

contract ScrollchainBlessingLicenseKit {
    address public steward;

    struct BlessingLicense {
        string sanctumName;
        string guardian;
        string blessingType;
        string jurisdiction;
        uint256 timestamp;
    }

    BlessingLicense[] public licenses;

    event BlessingLicenseIssued(string sanctum, string guardian, string type, string jurisdiction, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function issueLicense(string memory sanctumName, string memory guardian, string memory blessingType, string memory jurisdiction) public {
        require(msg.sender == steward, "Only steward can issue");
        licenses.push(BlessingLicense(sanctumName, guardian, blessingType, jurisdiction, block.timestamp));
        emit BlessingLicenseIssued(sanctumName, guardian, blessingType, jurisdiction, block.timestamp);
    }

    function getLicense(uint index) public view returns (string memory, string memory, string memory, string memory, uint256) {
        BlessingLicense memory l = licenses[index];
        return (l.sanctumName, l.guardian, l.blessingType, l.jurisdiction, l.timestamp);
    }

    function totalLicenses() public view returns (uint) {
        return licenses.length;
    }
}
