// SPDX-License-Identifier: SanctumProtection-License
pragma solidity ^0.8.0;

contract CivicSanctumProtectionLicenseKit {
    address public steward;

    struct ProtectionLicense {
        string sanctumName;
        string guardian;
        string protectionTier;
        string conflictZone;
        uint256 timestamp;
    }

    ProtectionLicense[] public licenses;

    event ProtectionLicenseIssued(string sanctumName, string guardian, string tier, string zone, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function issueLicense(string memory sanctumName, string memory guardian, string memory protectionTier, string memory conflictZone) public {
        require(msg.sender == steward, "Only steward can issue");
        licenses.push(ProtectionLicense(sanctumName, guardian, protectionTier, conflictZone, block.timestamp));
        emit ProtectionLicenseIssued(sanctumName, guardian, protectionTier, conflictZone, block.timestamp);
    }

    function getLicense(uint index) public view returns (string memory, string memory, string memory, string memory, uint256) {
        ProtectionLicense memory l = licenses[index];
        return (l.sanctumName, l.guardian, l.protectionTier, l.conflictZone, l.timestamp);
    }

    function totalLicenses() public view returns (uint) {
        return licenses.length;
    }
}
