// SPDX-License-Identifier: InspectionSanctum
pragma solidity ^0.8.19;

contract GlobalInspectionLedger {
    struct InspectionEvent {
        string inspectorEntity;
        string assetType; // e.g., "Medical Supplies", "Grain", "Machinery"
        string originCountry;
        string destinationCountry;
        string treatyName;
        uint256 quantity;
        bool inspected;
        bool compliant;
        string inspectionNote;
    }

    mapping(bytes32 => InspectionEvent) public events;

    event InspectionTagged(string inspectorEntity, string assetType, string originCountry, string destinationCountry);
    event ComplianceVerified(string inspectorEntity, string assetType);

    function tagInspection(string memory inspectorEntity, string memory assetType, string memory originCountry, string memory destinationCountry, string memory treatyName, uint256 quantity, string memory inspectionNote) public {
        bytes32 eventId = keccak256(abi.encodePacked(inspectorEntity, assetType, originCountry, destinationCountry, block.timestamp));
        events[eventId] = InspectionEvent(inspectorEntity, assetType, originCountry, destinationCountry, treatyName, quantity, false, false, inspectionNote);
        emit InspectionTagged(inspectorEntity, assetType, originCountry, destinationCountry);
    }

    function verifyCompliance(string memory inspectorEntity, string memory assetType, string memory originCountry, string memory destinationCountry) public {
        bytes32 eventId = keccak256(abi.encodePacked(inspectorEntity, assetType, originCountry, destinationCountry, block.timestamp));
        events[eventId].inspected = true;
        events[eventId].compliant = true;
        emit ComplianceVerified(inspectorEntity, assetType);
    }

    function getInspectionStatus(string memory inspectorEntity, string memory assetType, string memory originCountry, string memory destinationCountry) public view returns (InspectionEvent memory) {
        bytes32 eventId = keccak256(abi.encodePacked(inspectorEntity, assetType, originCountry, destinationCountry, block.timestamp));
        return events[eventId];
    }
}
