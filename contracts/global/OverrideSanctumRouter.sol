// SPDX-License-Identifier: SanctumOverride
pragma solidity ^0.8.19;

contract OverrideSanctumRouter {
    struct OverrideSignal {
        address actorID;
        string actorName;
        string overrideBasis; // e.g., "Grave Abuse", "Due Process Violation", "Unconstitutional Action"
        string jurisdiction; // e.g., "Judicial", "Executive", "Legislative"
        bool overrideActivated;
        string stewardNote;
    }

    mapping(address => OverrideSignal) public overrideRegistry;

    event OverrideTagged(address actorID, string overrideBasis);
    event OverrideActivated(address actorID);

    function tagOverride(address actorID, string memory actorName, string memory overrideBasis, string memory jurisdiction, string memory stewardNote) public {
        overrideRegistry[actorID] = OverrideSignal(actorID, actorName, overrideBasis, jurisdiction, false, stewardNote);
        emit OverrideTagged(actorID, overrideBasis);
    }

    function activateOverride(address actorID) public {
        require(bytes(overrideRegistry[actorID].actorName).length > 0, "Actor not tagged");
        overrideRegistry[actorID].overrideActivated = true;
        emit OverrideActivated(actorID);
    }

    function getOverrideStatus(address actorID) public view returns (OverrideSignal memory) {
        return overrideRegistry[actorID];
    }
}
