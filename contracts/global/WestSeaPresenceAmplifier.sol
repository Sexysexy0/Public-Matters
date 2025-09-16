// SPDX-License-Identifier: WestSeaSanctum
pragma solidity ^0.8.19;

contract WestSeaPresenceAmplifier {
    struct PresenceSignal {
        string vesselID;
        string region;
        string missionType;
        bool active;
        string stewardNote;
    }

    mapping(string => PresenceSignal) public presenceRegistry;

    event SignalTagged(string vesselID, string missionType);
    event PresenceActivated(string vesselID);

    function tagPresence(string memory vesselID, string memory region, string memory missionType, string memory stewardNote) public {
        presenceRegistry[vesselID] = PresenceSignal(vesselID, region, missionType, false, stewardNote);
        emit SignalTagged(vesselID, missionType);
    }

    function activatePresence(string memory vesselID) public {
        require(bytes(presenceRegistry[vesselID].region).length > 0, "Region not tagged");
        presenceRegistry[vesselID].active = true;
        emit PresenceActivated(vesselID);
    }

    function getPresenceStatus(string memory vesselID) public view returns (PresenceSignal memory) {
        return presenceRegistry[vesselID];
    }
}
