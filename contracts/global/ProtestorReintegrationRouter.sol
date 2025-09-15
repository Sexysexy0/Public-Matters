// SPDX-License-Identifier: ReintegrationSanctum
pragma solidity ^0.8.19;

contract ProtestorReintegrationRouter {
    struct ReintegrationEvent {
        string protestorName;
        string country;
        bool criminalRecord;
        bool verifiedPeaceful;
        bool reintegrationApproved;
        string civicNote;
        bool educationEnrolled;
    }

    mapping(bytes32 => ReintegrationEvent) public events;

    event ProtestorTagged(string protestorName, string country);
    event ReintegrationApproved(string protestorName);

    function tagProtestor(string memory protestorName, string memory country, bool criminalRecord, bool verifiedPeaceful, string memory civicNote) public {
        bytes32 eventId = keccak256(abi.encodePacked(protestorName, country, block.timestamp));
        events[eventId] = ReintegrationEvent(protestorName, country, criminalRecord, verifiedPeaceful, false, civicNote, false);
        emit ProtestorTagged(protestorName, country);
    }

    function approveReintegration(string memory protestorName, string memory country) public {
        bytes32 eventId = keccak256(abi.encodePacked(protestorName, country, block.timestamp));
        events[eventId].reintegrationApproved = true;
        emit ReintegrationApproved(protestorName);
    }

    function enrollEducation(string memory protestorName, string memory country) public {
        bytes32 eventId = keccak256(abi.encodePacked(protestorName, country, block.timestamp));
        events[eventId].educationEnrolled = true;
    }

    function getReintegrationStatus(string memory protestorName, string memory country) public view returns (ReintegrationEvent memory) {
        bytes32 eventId = keccak256(abi.encodePacked(protestorName, country, block.timestamp));
        return events[eventId];
    }
}
