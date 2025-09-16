// SPDX-License-Identifier: LegitimacySanctum
pragma solidity ^0.8.19;

contract HumanitarianLegitimacyRouter {
    struct LegitimacySignal {
        address orgID;
        string missionZone;
        string legitimacyTag; // e.g., "UN Mandated", "Neutral Actor", "Local Partner"
        bool verified;
        string stewardNote;
    }

    mapping(address => LegitimacySignal) public legitimacyRegistry;

    event LegitimacyTagged(address orgID, string missionZone);
    event LegitimacyVerified(address orgID);

    function tagLegitimacy(address orgID, string memory missionZone, string memory legitimacyTag, string memory stewardNote) public {
        legitimacyRegistry[orgID] = LegitimacySignal(orgID, missionZone, legitimacyTag, false, stewardNote);
        emit LegitimacyTagged(orgID, missionZone);
    }

    function verifyLegitimacy(address orgID) public {
        require(bytes(legitimacyRegistry[orgID].missionZone).length > 0, "Org not tagged");
        legitimacyRegistry[orgID].verified = true;
        emit LegitimacyVerified(orgID);
    }

    function getLegitimacyStatus(address orgID) public view returns (LegitimacySignal memory) {
        return legitimacyRegistry[orgID];
    }
}
