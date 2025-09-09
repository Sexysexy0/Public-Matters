// SPDX-License-Identifier: FirewallBlessing-License
pragma solidity ^0.8.0;

contract FirewallBlessingLicenseKit {
    address public steward;

    struct BlessingLicense {
        string actor;
        string protectionClause;
        string sanctumZone;
        bool verified;
        uint256 timestamp;
    }

    BlessingLicense[] public licenses;

    event BlessingLicenseIssued(string actor, string clause, string zone, bool verified, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function issueLicense(string memory actor, string memory protectionClause, string memory sanctumZone, bool verified) public {
        require(msg.sender == steward, "Only steward can issue");
        licenses.push(BlessingLicense(actor, protectionClause, sanctumZone, verified, block.timestamp));
        emit BlessingLicenseIssued(actor, protectionClause, sanctumZone, verified, block.timestamp);
    }

    function getLicense(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        BlessingLicense memory l = licenses[index];
        return (l.actor, l.protectionClause, l.sanctumZone, l.verified, l.timestamp);
    }
}
