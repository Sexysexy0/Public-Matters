// SPDX-License-Identifier: OverrideSanctum
pragma solidity ^0.8.19;

contract SanctumOverrideBeacon {
    struct OverrideBeacon {
        address actorID;
        string actorName;
        string overrideTrigger; // e.g., "Grave Abuse", "Due Process Breach", "Unconstitutional Action"
        string jurisdiction; // e.g., "Judicial", "Executive", "Legislative"
        bool beaconActivated;
        string stewardNote;
    }

    mapping(address => OverrideBeacon) public beaconRegistry;

    event BeaconTagged(address actorID, string overrideTrigger);
    event BeaconActivated(address actorID);

    function tagBeacon(address actorID, string memory actorName, string memory overrideTrigger, string memory jurisdiction, string memory stewardNote) public {
        beaconRegistry[actorID] = OverrideBeacon(actorID, actorName, overrideTrigger, jurisdiction, false, stewardNote);
        emit BeaconTagged(actorID, overrideTrigger);
    }

    function activateBeacon(address actorID) public {
        require(bytes(beaconRegistry[actorID].actorName).length > 0, "Beacon not tagged");
        beaconRegistry[actorID].beaconActivated = true;
        emit BeaconActivated(actorID);
    }

    function getBeaconStatus(address actorID) public view returns (OverrideBeacon memory) {
        return beaconRegistry[actorID];
    }
}
