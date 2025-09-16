// SPDX-License-Identifier: CovenantSanctum
pragma solidity ^0.8.19;

contract EmergencyCovenantRouter {
    struct CovenantSignal {
        address orgID;
        string crisisZone;
        string sanctumType; // e.g., "Safe Zone", "Emergency Shelter", "Dignity Corridor"
        bool activated;
        bool legitimacyVerified;
        string stewardNote;
    }

    mapping(address => CovenantSignal) public covenantRegistry;

    event CovenantTagged(address orgID, string sanctumType);
    event CovenantActivated(address orgID);

    function tagCovenant(address orgID, string memory crisisZone, string memory sanctumType, string memory stewardNote) public {
        covenantRegistry[orgID] = CovenantSignal(orgID, crisisZone, sanctumType, false, false, stewardNote);
        emit CovenantTagged(orgID, sanctumType);
    }

    function activateCovenant(address orgID) public {
        require(bytes(covenantRegistry[orgID].sanctumType).length > 0, "Covenant not tagged");
        covenantRegistry[orgID].activated = true;
        emit CovenantActivated(orgID);
    }

    function verifyLegitimacy(address orgID) public {
        covenantRegistry[orgID].legitimacyVerified = true;
    }

    function getCovenantStatus(address orgID) public view returns (CovenantSignal memory) {
        return covenantRegistry[orgID];
    }
}
