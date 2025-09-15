// SPDX-License-Identifier: CustomsSanctum
pragma solidity ^0.8.19;

contract CustomsEfficiencyRouter {
    struct ClearanceEvent {
        string exporterName;
        string country;
        string productType;
        string HSCode;
        uint256 declaredValueUSD;
        bool documentsVerified;
        bool dutiesPaid;
        bool released;
        string reformProtocol;
        uint256 timestamp;
    }

    mapping(bytes32 => ClearanceEvent) public events;

    event ClearanceTagged(string exporterName, string productType);
    event ClearanceReleased(string exporterName, string productType);

    function tagClearance(string memory exporterName, string memory country, string memory productType, string memory HSCode, uint256 declaredValueUSD, string memory reformProtocol) public {
        bytes32 eventId = keccak256(abi.encodePacked(exporterName, productType, block.timestamp));
        events[eventId] = ClearanceEvent(exporterName, country, productType, HSCode, declaredValueUSD, false, false, false, reformProtocol, block.timestamp);
        emit ClearanceTagged(exporterName, productType);
    }

    function releaseClearance(string memory exporterName, string memory productType) public {
        bytes32 eventId = keccak256(abi.encodePacked(exporterName, productType, block.timestamp));
        events[eventId].documentsVerified = true;
        events[eventId].dutiesPaid = true;
        events[eventId].released = true;
        emit ClearanceReleased(exporterName, productType);
    }

    function getClearanceStatus(string memory exporterName, string memory productType) public view returns (ClearanceEvent memory) {
        bytes32 eventId = keccak256(abi.encodePacked(exporterName, productType, block.timestamp));
        return events[eventId];
    }
}
