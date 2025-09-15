// SPDX-License-Identifier: IntegrationSanctum
pragma solidity ^0.8.19;

contract BarrierReductionLedger {
    struct BarrierEvent {
        string memberState;
        string barrierType; // e.g., "Non-Tariff", "Regulatory", "Logistics", "Digital"
        string sector; // e.g., "Agri-Food", "Automotive", "Healthcare", "E-Commerce"
        string resolutionProtocol;
        bool resolved;
        string treatyAlignedWith;
        uint256 timestamp;
    }

    mapping(bytes32 => BarrierEvent) public events;

    event BarrierTagged(string memberState, string barrierType, string sector);
    event BarrierResolved(string memberState, string barrierType);

    function tagBarrier(string memory memberState, string memory barrierType, string memory sector, string memory resolutionProtocol, string memory treatyAlignedWith) public {
        bytes32 eventId = keccak256(abi.encodePacked(memberState, barrierType, sector, block.timestamp));
        events[eventId] = BarrierEvent(memberState, barrierType, sector, resolutionProtocol, false, treatyAlignedWith, block.timestamp);
        emit BarrierTagged(memberState, barrierType, sector);
    }

    function resolveBarrier(string memory memberState, string memory barrierType, string memory sector) public {
        bytes32 eventId = keccak256(abi.encodePacked(memberState, barrierType, sector, block.timestamp));
        events[eventId].resolved = true;
        emit BarrierResolved(memberState, barrierType);
    }

    function getBarrierStatus(string memory memberState, string memory barrierType, string memory sector) public view returns (BarrierEvent memory) {
        bytes32 eventId = keccak256(abi.encodePacked(memberState, barrierType, sector, block.timestamp));
        return events[eventId];
    }
}
