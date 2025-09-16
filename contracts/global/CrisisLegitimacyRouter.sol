// SPDX-License-Identifier: LegitimacySanctum
pragma solidity ^0.8.19;

contract CrisisLegitimacyRouter {
    struct LegitimacySignal {
        address orgID;
        string crisisZone;
        string legitimacyTag; // e.g., "ERC Mandated", "Neutral Actor", "Cluster Lead"
        bool verified;
        string stewardNote;
    }

    mapping(address => LegitimacySignal) public legitimacyRegistry;

    event LegitimacyTagged(address orgID, string crisisZone);
    event LegitimacyVerified(address orgID);

    function tagLegitimacy(address orgID, string memory crisisZone, string memory legitimacyTag, string memory stewardNote) public {
        legitimacyRegistry[orgID] = LegitimacySignal(orgID, crisisZone, legitimacyTag, false, stewardNote);
        emit LegitimacyTagged(orgID, crisisZone);
    }

    function verifyLegitimacy(address orgID) public {
        require(bytes(legitimacyRegistry[orgID].crisisZone).length > 0, "Org not tagged");
        legitimacyRegistry[orgID].verified = true;
        emit LegitimacyVerified(orgID);
    }

    function getLegitimacyStatus(address orgID) public view returns (LegitimacySignal memory) {
        return legitimacyRegistry[orgID];
    }
}
