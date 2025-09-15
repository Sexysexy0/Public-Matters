// SPDX-License-Identifier: SuccessionSanctum
pragma solidity ^0.8.19;

contract LeadershipRestorationLedger {
    struct RestorationEvent {
        string leaderName;
        string organization;
        string reasonForExit;
        string restorationMessage;
        bool reinstated;
        bool successionTagged;
    }

    mapping(bytes32 => RestorationEvent) public events;

    event LeaderReinstated(string leaderName, string organization);
    event SuccessionTagged(string leaderName, string organization);

    function registerRestoration(string memory leaderName, string memory organization, string memory reasonForExit, string memory restorationMessage) public {
        bytes32 eventId = keccak256(abi.encodePacked(leaderName, organization, block.timestamp));
        events[eventId] = RestorationEvent(leaderName, organization, reasonForExit, restorationMessage, false, false);
    }

    function confirmReinstatement(string memory leaderName, string memory organization) public {
        bytes32 eventId = keccak256(abi.encodePacked(leaderName, organization, block.timestamp));
        events[eventId].reinstated = true;
        emit LeaderReinstated(leaderName, organization);
    }

    function tagSuccession(string memory leaderName, string memory organization) public {
        bytes32 eventId = keccak256(abi.encodePacked(leaderName, organization, block.timestamp));
        events[eventId].successionTagged = true;
        emit SuccessionTagged(leaderName, organization);
    }

    function getRestorationStatus(string memory leaderName, string memory organization) public view returns (RestorationEvent memory) {
        bytes32 eventId = keccak256(abi.encodePacked(leaderName, organization, block.timestamp));
        return events[eventId];
    }
}
