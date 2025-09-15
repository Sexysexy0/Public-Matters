// SPDX-License-Identifier: MigrationSanctum
pragma solidity ^0.8.19;

contract VisaRestorationBeacon {
    struct SponsorshipEvent {
        string sponsorName;
        string beneficiaryName;
        string visaType; // e.g., "H-1B", "F-1", "O-1"
        string country;
        uint256 timestamp;
        bool restored;
        bool broadcasted;
    }

    mapping(bytes32 => SponsorshipEvent) public events;

    event SponsorshipTagged(string sponsorName, string beneficiaryName);
    event RestorationBroadcasted(string sponsorName, string beneficiaryName);

    function tagSponsorship(string memory sponsorName, string memory beneficiaryName, string memory visaType, string memory country) public {
        bytes32 eventId = keccak256(abi.encodePacked(sponsorName, beneficiaryName, visaType, country, block.timestamp));
        events[eventId] = SponsorshipEvent(sponsorName, beneficiaryName, visaType, country, block.timestamp, false, false);
        emit SponsorshipTagged(sponsorName, beneficiaryName);
    }

    function broadcastRestoration(string memory sponsorName, string memory beneficiaryName) public {
        bytes32 eventId = keccak256(abi.encodePacked(sponsorName, beneficiaryName, block.timestamp));
        events[eventId].restored = true;
        events[eventId].broadcasted = true;
        emit RestorationBroadcasted(sponsorName, beneficiaryName);
    }

    function getEventStatus(string memory sponsorName, string memory beneficiaryName) public view returns (SponsorshipEvent memory) {
        bytes32 eventId = keccak256(abi.encodePacked(sponsorName, beneficiaryName, block.timestamp));
        return events[eventId];
    }
}
