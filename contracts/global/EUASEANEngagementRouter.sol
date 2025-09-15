// SPDX-License-Identifier: EngagementSanctum
pragma solidity ^0.8.19;

contract EUASEANEngagementRouter {
    struct EngagementEvent {
        string EUEntity;
        string ASEANMember;
        string engagementType; // e.g., "Trade", "Education", "Climate", "Logistics"
        string initiativeName;
        bool activated;
        string civicNote;
        uint256 timestamp;
    }

    mapping(bytes32 => EngagementEvent) public events;

    event EngagementTagged(string EUEntity, string ASEANMember, string engagementType);
    event EngagementActivated(string initiativeName);

    function tagEngagement(string memory EUEntity, string memory ASEANMember, string memory engagementType, string memory initiativeName, string memory civicNote) public {
        bytes32 eventId = keccak256(abi.encodePacked(EUEntity, ASEANMember, initiativeName, block.timestamp));
        events[eventId] = EngagementEvent(EUEntity, ASEANMember, engagementType, initiativeName, false, civicNote, block.timestamp);
        emit EngagementTagged(EUEntity, ASEANMember, engagementType);
    }

    function activateEngagement(string memory initiativeName) public {
        bytes32 eventId = keccak256(abi.encodePacked(initiativeName, block.timestamp));
        events[eventId].activated = true;
        emit EngagementActivated(initiativeName);
    }

    function getEngagementStatus(string memory EUEntity, string memory ASEANMember, string memory initiativeName) public view returns (EngagementEvent memory) {
        bytes32 eventId = keccak256(abi.encodePacked(EUEntity, ASEANMember, initiativeName, block.timestamp));
        return events[eventId];
    }
}
