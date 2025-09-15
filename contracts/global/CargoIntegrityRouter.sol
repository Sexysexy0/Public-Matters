// SPDX-License-Identifier: CargoSanctum
pragma solidity ^0.8.19;

contract CargoIntegrityRouter {
    struct Shipment {
        string trackingId;
        string origin;
        string destination;
        bool verified;
        bool customsCleared;
        bool safeDelivery;
    }

    mapping(bytes32 => Shipment) public shipments;

    event ShipmentTagged(string trackingId);
    event Verified(string trackingId);
    event CustomsCleared(string trackingId);
    event SafeDeliveryConfirmed(string trackingId);

    function tagShipment(string memory trackingId, string memory origin, string memory destination) public {
        bytes32 shipmentId = keccak256(abi.encodePacked(trackingId));
        shipments[shipmentId] = Shipment(trackingId, origin, destination, false, false, false);
        emit ShipmentTagged(trackingId);
    }

    function verifyShipment(string memory trackingId) public {
        bytes32 shipmentId = keccak256(abi.encodePacked(trackingId));
        shipments[shipmentId].verified = true;
        emit Verified(trackingId);
    }

    function clearCustoms(string memory trackingId) public {
        bytes32 shipmentId = keccak256(abi.encodePacked(trackingId));
        shipments[shipmentId].customsCleared = true;
        emit CustomsCleared(trackingId);
    }

    function confirmSafeDelivery(string memory trackingId) public {
        bytes32 shipmentId = keccak256(abi.encodePacked(trackingId));
        shipments[shipmentId].safeDelivery = true;
        emit SafeDeliveryConfirmed(trackingId);
    }

    function getShipmentStatus(string memory trackingId) public view returns (Shipment memory) {
        bytes32 shipmentId = keccak256(abi.encodePacked(trackingId));
        return shipments[shipmentId];
    }
}
