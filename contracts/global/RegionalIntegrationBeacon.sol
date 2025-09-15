// SPDX-License-Identifier: ASEANSanctum
pragma solidity ^0.8.19;

contract RegionalIntegrationBeacon {
    struct IntegrationEvent {
        string memberState;
        string treatyName;
        string barrierType; // e.g., "Non-Tariff", "Regulatory", "Logistics"
        bool resolved;
        string resolutionNote;
        uint256 timestamp;
    }

    mapping(bytes32 => IntegrationEvent) public events;

    event TreatyAligned(string memberState, string treatyName);
    event BarrierResolved(string memberState, string barrierType);

    function tagAlignment(string memory memberState, string memory treatyName, string memory barrierType, string memory resolutionNote) public {
        bytes32 eventId = keccak256(abi.encodePacked(memberState, treatyName, block.timestamp));
        events[eventId] = IntegrationEvent(memberState, treatyName, barrierType, false, resolutionNote, block.timestamp);
        emit TreatyAligned(memberState, treatyName);
    }

    function resolveBarrier(string memory memberState, string memory barrierType) public {
        bytes32 eventId = keccak256(abi.encodePacked(memberState, barrierType, block.timestamp));
        events[eventId].resolved = true;
        emit BarrierResolved(memberState, barrierType);
    }

    function getIntegrationStatus(string memory memberState, string memory treatyName) public view returns (IntegrationEvent memory) {
        bytes32 eventId = keccak256(abi.encodePacked(memberState, treatyName, block.timestamp));
        return events[eventId];
    }
}
