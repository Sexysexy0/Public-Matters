// SPDX-License-Identifier: CivicSanctum
pragma solidity ^0.8.19;

contract IdeologyReconciliationBeacon {
    struct ReconciliationEvent {
        string stewardName;
        string ideology;
        string institution; // e.g., "Education", "Media", "Government"
        string healingMessage;
        bool rehabilitated;
        bool broadcasted;
    }

    mapping(bytes32 => ReconciliationEvent) public events;

    event ReconciliationTagged(string stewardName, string ideology);
    event HealingBroadcasted(string stewardName, string healingMessage);
    event RestorationCompleted(string stewardName);

    function tagReconciliation(string memory stewardName, string memory ideology, string memory institution, string memory healingMessage) public {
        bytes32 eventId = keccak256(abi.encodePacked(stewardName, ideology, institution, block.timestamp));
        events[eventId] = ReconciliationEvent(stewardName, ideology, institution, healingMessage, false, false);
        emit ReconciliationTagged(stewardName, ideology);
    }

    function broadcastHealing(string memory stewardName, string memory ideology, string memory healingMessage) public {
        bytes32 eventId = keccak256(abi.encodePacked(stewardName, ideology, block.timestamp));
        events[eventId].broadcasted = true;
        events[eventId].healingMessage = healingMessage;
        emit HealingBroadcasted(stewardName, healingMessage);
    }

    function completeRestoration(string memory stewardName, string memory ideology) public {
        bytes32 eventId = keccak256(abi.encodePacked(stewardName, ideology, block.timestamp));
        events[eventId].rehabilitated = true;
        emit RestorationCompleted(stewardName);
    }

    function getEventStatus(string memory stewardName, string memory ideology) public view returns (ReconciliationEvent memory) {
        bytes32 eventId = keccak256(abi.encodePacked(stewardName, ideology, block.timestamp));
        return events[eventId];
    }
}
