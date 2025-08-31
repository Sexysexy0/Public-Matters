// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract DamayAudit {
    struct SiteAudit {
        string siteName;
        bool ancestral;
        bool civicConsent;
        string steward;
        uint256 timestamp;
    }

    SiteAudit[] public audits;

    event SiteAudited(string siteName, bool ancestral, bool civicConsent, string steward);

    function auditSite(string memory siteName, bool ancestral, bool consent, string memory steward) public {
        audits.push(SiteAudit(siteName, ancestral, consent, steward, block.timestamp));
        emit SiteAudited(siteName, ancestral, consent, steward);
    }

    function getAudit(uint index) public view returns (string memory, bool, bool, string memory, uint256) {
        SiteAudit memory a = audits[index];
        return (a.siteName, a.ancestral, a.civicConsent, a.steward, a.timestamp);
    }
}
