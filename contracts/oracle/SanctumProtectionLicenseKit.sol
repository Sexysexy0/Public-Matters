// SPDX-License-Identifier: SanctumProtection-License
pragma solidity ^0.8.0;

contract SanctumProtectionLicenseKit {
    address public steward;

    struct ProtectionLicense {
        string sanctumName;
        string guardian;
        string protectionTier;
        string clause;
        uint256 timestamp;
    }

    ProtectionLicense[] public licenses;

    event ProtectionLicenseIssued(string sanctumName, string guardian, string tier, string clause, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function issueLicense(string memory sanctumName, string memory guardian, string memory protectionTier, string memory clause) public {
        require(msg.sender == steward, "Only steward can issue");
        licenses.push(ProtectionLicense(sanctumName, guardian, protectionTier, clause, block.timestamp));
        emit ProtectionLicenseIssued(sanctumName, guardian, protectionTier, clause, block.timestamp);
    }

    function getLicense(uint index) public view returns (string memory, string memory, string memory, string memory, uint256) {
        ProtectionLicense memory l = licenses[index];
        return (l.sanctumName, l.guardian, l.protectionTier, l.clause, l.timestamp);
    }

    function totalLicenses() public view returns (uint) {
        return licenses.length;
    }
}
