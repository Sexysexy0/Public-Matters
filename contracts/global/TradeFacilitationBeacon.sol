// SPDX-License-Identifier: FacilitationSanctum
pragma solidity ^0.8.19;

contract TradeFacilitationBeacon {
    struct FacilitationEvent {
        string country;
        string reformType; // e.g., "Digital Customs", "ATA Carnet", "AEO Program", "Transit Protocol"
        string corridor; // e.g., "PH-KR FTA", "ASEAN Single Window", "ACTS"
        bool implemented;
        string facilitationNote;
        uint256 timestamp;
    }

    mapping(bytes32 => FacilitationEvent) public events;

    event ReformTagged(string country, string reformType, string corridor);
    event ReformVerified(string country, string reformType);

    function tagReform(string memory country, string memory reformType, string memory corridor, string memory facilitationNote) public {
        bytes32 eventId = keccak256(abi.encodePacked(country, reformType, corridor, block.timestamp));
        events[eventId] = FacilitationEvent(country, reformType, corridor, false, facilitationNote, block.timestamp);
        emit ReformTagged(country, reformType, corridor);
    }

    function verifyReform(string memory country, string memory reformType, string memory corridor) public {
        bytes32 eventId = keccak256(abi.encodePacked(country, reformType, corridor, block.timestamp));
        events[eventId].implemented = true;
        emit ReformVerified(country, reformType);
    }

    function getFacilitationStatus(string memory country, string memory reformType, string memory corridor) public view returns (FacilitationEvent memory) {
        bytes32 eventId = keccak256(abi.encodePacked(country, reformType, corridor, block.timestamp));
        return events[eventId];
    }
}
