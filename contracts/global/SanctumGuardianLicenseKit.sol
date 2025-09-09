// SPDX-License-Identifier: SanctumGuardian-License
pragma solidity ^0.8.0;

contract SanctumGuardianLicenseKit {
    address public steward;

    struct GuardianLicense {
        string guardian;
        string protectionClause;
        string sanctumZone;
        bool verified;
        uint256 timestamp;
    }

    GuardianLicense[] public licenses;

    event GuardianLicenseIssued(string guardian, string clause, string zone, bool verified, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function issueLicense(string memory guardian, string memory protectionClause, string memory sanctumZone, bool verified) public {
        require(msg.sender == steward, "Only steward can issue");
        licenses.push(GuardianLicense(guardian, protectionClause, sanctumZone, verified, block.timestamp));
        emit GuardianLicenseIssued(guardian, protectionClause, sanctumZone, verified, block.timestamp);
    }

    function getLicense(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        GuardianLicense memory l = licenses[index];
        return (l.guardian, l.protectionClause, l.sanctumZone, l.verified, l.timestamp);
    }
}
