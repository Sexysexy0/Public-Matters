// SPDX-License-Identifier: FirewallSanctum
pragma solidity ^0.8.19;

contract RogueRemovalInterceptor {
    struct RemovalSignal {
        address officerID;
        string officerName;
        string removalBasis; // e.g., "Unverified Allegation", "Policy Disagreement", "Political Retaliation"
        bool dueProcessTriggered;
        bool overrideRequested;
        string stewardNote;
    }

    mapping(address => RemovalSignal) public removalRegistry;

    event RemovalTagged(address officerID, string removalBasis);
    event OverrideRequested(address officerID);

    function tagRemoval(address officerID, string memory officerName, string memory removalBasis, bool dueProcessTriggered, string memory stewardNote) public {
        removalRegistry[officerID] = RemovalSignal(officerID, officerName, removalBasis, dueProcessTriggered, false, stewardNote);
        emit RemovalTagged(officerID, removalBasis);
    }

    function requestOverride(address officerID) public {
        require(bytes(removalRegistry[officerID].officerName).length > 0, "Officer not tagged");
        removalRegistry[officerID].overrideRequested = true;
        emit OverrideRequested(officerID);
    }

    function getRemovalStatus(address officerID) public view returns (RemovalSignal memory) {
        return removalRegistry[officerID];
    }
}
