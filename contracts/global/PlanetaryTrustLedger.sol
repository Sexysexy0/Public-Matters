// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PlanetaryTrustLedger {
    struct TrustEvent {
        string nationA;
        string nationB;
        string eventType;
        uint256 emotionalAPR;
        string auditNote;
        uint256 timestamp;
    }

    TrustEvent[] public events;

    event TrustLogged(string nationA, string nationB, string eventType, uint256 emotionalAPR, string auditNote);

    function logTrustEvent(
        string memory _nationA,
        string memory _nationB,
        string memory _eventType,
        uint256 _emotionalAPR,
        string memory _auditNote
    ) public {
        events.push(TrustEvent(_nationA, _nationB, _eventType, _emotionalAPR, _auditNote, block.timestamp));
        emit TrustLogged(_nationA, _nationB, _eventType, _emotionalAPR, _auditNote);
    }

    function getAllTrustEvents() public view returns (TrustEvent[] memory) {
        return events;
    }
}
