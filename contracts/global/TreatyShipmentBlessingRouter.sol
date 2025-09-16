// SPDX-License-Identifier: TreatySanctum
pragma solidity ^0.8.19;

contract TreatyShipmentBlessingRouter {
    struct ShipmentSignal {
        string shipmentID;
        string treatyName;
        string commodityType;
        bool blessed;
        string stewardNote;
    }

    mapping(string => ShipmentSignal) public shipmentRegistry;

    event ShipmentTagged(string shipmentID, string treatyName, string commodityType);
    event ShipmentBlessed(string shipmentID);

    function tagShipment(string memory shipmentID, string memory treatyName, string memory commodityType, string memory stewardNote) public {
        shipmentRegistry[shipmentID] = ShipmentSignal(shipmentID, treatyName, commodityType, false, stewardNote);
        emit ShipmentTagged(shipmentID, treatyName, commodityType);
    }

    function blessShipment(string memory shipmentID) public {
        require(bytes(shipmentRegistry[shipmentID].treatyName).length > 0, "Shipment not tagged");
        shipmentRegistry[shipmentID].blessed = true;
        emit ShipmentBlessed(shipmentID);
    }

    function getShipmentStatus(string memory shipmentID) public view returns (ShipmentSignal memory) {
        return shipmentRegistry[shipmentID];
    }
}
