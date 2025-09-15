// SPDX-License-Identifier: LaborSanctum
pragma solidity ^0.8.19;

contract LaborEquityRouter {
    struct LaborEvent {
        string workerName;
        string classification; // "Freelancer", "Displaced", "Migrant"
        string contractHash;
        bool writtenContract;
        bool prepaid;
        bool paidOnTime;
        bool hazardPayEligible;
        bool equityActivated;
        string dignityNote;
    }

    mapping(bytes32 => LaborEvent) public events;

    event LaborTagged(string workerName, string classification);
    event EquityActivated(string workerName);

    function tagLabor(string memory workerName, string memory classification, string memory contractHash, bool writtenContract, bool prepaid, bool paidOnTime, bool hazardPayEligible, string memory dignityNote) public {
        bytes32 eventId = keccak256(abi.encodePacked(workerName, classification, block.timestamp));
        events[eventId] = LaborEvent(workerName, classification, contractHash, writtenContract, prepaid, paidOnTime, hazardPayEligible, false, dignityNote);
        emit LaborTagged(workerName, classification);
    }

    function activateEquity(string memory workerName, string memory classification) public {
        bytes32 eventId = keccak256(abi.encodePacked(workerName, classification, block.timestamp));
        events[eventId].equityActivated = true;
        emit EquityActivated(workerName);
    }

    function getLaborStatus(string memory workerName, string memory classification) public view returns (LaborEvent memory) {
        bytes32 eventId = keccak256(abi.encodePacked(workerName, classification, block.timestamp));
        return events[eventId];
    }
}
