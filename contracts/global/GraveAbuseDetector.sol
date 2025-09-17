// SPDX-License-Identifier: OverrideSanctum
pragma solidity ^0.8.19;

contract GraveAbuseDetector {
    struct AbuseSignal {
        address actorID;
        string actorName;
        string abuseType; // e.g., "Capricious Judgment", "Political Retaliation", "Due Process Violation"
        string jurisdiction; // e.g., "Judicial", "Executive", "Quasi-Judicial"
        bool overrideTriggered;
        string stewardNote;
    }

    mapping(address => AbuseSignal) public abuseRegistry;

    event AbuseTagged(address actorID, string abuseType);
    event OverrideTriggered(address actorID);

    function tagAbuse(address actorID, string memory actorName, string memory abuseType, string memory jurisdiction, string memory stewardNote) public {
        abuseRegistry[actorID] = AbuseSignal(actorID, actorName, abuseType, jurisdiction, false, stewardNote);
        emit AbuseTagged(actorID, abuseType);
    }

    function triggerOverride(address actorID) public {
        require(bytes(abuseRegistry[actorID].actorName).length > 0, "Actor not tagged");
        abuseRegistry[actorID].overrideTriggered = true;
        emit OverrideTriggered(actorID);
    }

    function getAbuseStatus(address actorID) public view returns (AbuseSignal memory) {
        return abuseRegistry[actorID];
    }
}
