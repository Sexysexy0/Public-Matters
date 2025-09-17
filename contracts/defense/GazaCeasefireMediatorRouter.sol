// SPDX-License-Identifier: PeaceSanctum
pragma solidity ^0.8.19;

contract GazaCeasefireMediatorRouter {
    struct CeasefireSignal {
        address mediatorID;
        string mediatorName; // e.g., "Qatar", "Egypt", "United States"
        string agreementPhase; // e.g., "Initial Pause", "Hostage Exchange", "Permanent Ceasefire"
        bool humanitarianAccessGranted;
        bool regionalDeescalationConfirmed;
        string stewardNote;
    }

    mapping(address => CeasefireSignal) public ceasefireRegistry;

    event CeasefireTagged(address mediatorID, string agreementPhase);
    event DeescalationConfirmed(address mediatorID);

    function tagCeasefire(
        address mediatorID,
        string memory mediatorName,
        string memory agreementPhase,
        bool humanitarianAccessGranted,
        bool regionalDeescalationConfirmed,
        string memory stewardNote
    ) public {
        ceasefireRegistry[mediatorID] = CeasefireSignal(
            mediatorID,
            mediatorName,
            agreementPhase,
            humanitarianAccessGranted,
            regionalDeescalationConfirmed,
            stewardNote
        );
        emit CeasefireTagged(mediatorID, agreementPhase);
    }

    function confirmDeescalation(address mediatorID) public {
        require(bytes(ceasefireRegistry[mediatorID].mediatorName).length > 0, "Ceasefire not tagged");
        ceasefireRegistry[mediatorID].regionalDeescalationConfirmed = true;
        emit DeescalationConfirmed(mediatorID);
    }

    function getCeasefireStatus(address mediatorID) public view returns (CeasefireSignal memory) {
        return ceasefireRegistry[mediatorID];
    }
}
