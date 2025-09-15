// SPDX-License-Identifier: AmnestySanctum
pragma solidity ^0.8.19;

contract CivicAmnestyBeacon {
    struct AmnestyEvent {
        string protestorName;
        string country;
        bool criminalRecord;
        bool verifiedPeaceful;
        bool amnestyGranted;
        bool reintegrationApproved;
        string reintegrationNote;
    }

    mapping(bytes32 => AmnestyEvent) public events;

    event AmnestyTagged(string protestorName, string country);
    event AmnestyGranted(string protestorName);
    event ReintegrationActivated(string protestorName);

    function tagProtestor(string memory protestorName, string memory country, bool criminalRecord, bool verifiedPeaceful, string memory reintegrationNote) public {
        bytes32 eventId = keccak256(abi.encodePacked(protestorName, country, block.timestamp));
        events[eventId] = AmnestyEvent(protestorName, country, criminalRecord, verifiedPeaceful, false, false, reintegrationNote);
        emit AmnestyTagged(protestorName, country);
    }

    function grantAmnesty(string memory protestorName, string memory country) public {
        bytes32 eventId = keccak256(abi.encodePacked(protestorName, country, block.timestamp));
        events[eventId].amnestyGranted = true;
        emit AmnestyGranted(protestorName);
    }

    function activateReintegration(string memory protestorName, string memory country) public {
        bytes32 eventId = keccak256(abi.encodePacked(protestorName, country, block.timestamp));
        events[eventId].reintegrationApproved = true;
        emit ReintegrationActivated(protestorName);
    }

    function getAmnestyStatus(string memory protestorName, string memory country) public view returns (AmnestyEvent memory) {
        bytes32 eventId = keccak256(abi.encodePacked(protestorName, country, block.timestamp));
        return events[eventId];
    }
}
