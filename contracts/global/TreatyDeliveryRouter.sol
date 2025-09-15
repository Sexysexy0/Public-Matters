// SPDX-License-Identifier: DeliverySanctum
pragma solidity ^0.8.19;

contract TreatyDeliveryRouter {
    struct DeliveryEvent {
        string treatyName;
        string assetType; // e.g., "Gold", "Grain", "Oil"
        string originCountry;
        string destinationCountry;
        string collectorEntity;
        uint256 quantity;
        bool delivered;
        bool verified;
        string deliveryNote;
    }

    mapping(bytes32 => DeliveryEvent) public deliveries;

    event DeliveryTagged(string treatyName, string assetType, string originCountry, string destinationCountry);
    event DeliveryVerified(string collectorEntity, string assetType);

    function tagDelivery(string memory treatyName, string memory assetType, string memory originCountry, string memory destinationCountry, string memory collectorEntity, uint256 quantity, string memory deliveryNote) public {
        bytes32 deliveryId = keccak256(abi.encodePacked(treatyName, assetType, originCountry, destinationCountry, block.timestamp));
        deliveries[deliveryId] = DeliveryEvent(treatyName, assetType, originCountry, destinationCountry, collectorEntity, quantity, false, false, deliveryNote);
        emit DeliveryTagged(treatyName, assetType, originCountry, destinationCountry);
    }

    function verifyDelivery(string memory treatyName, string memory assetType, string memory originCountry, string memory destinationCountry, string memory collectorEntity) public {
        bytes32 deliveryId = keccak256(abi.encodePacked(treatyName, assetType, originCountry, destinationCountry, block.timestamp));
        deliveries[deliveryId].delivered = true;
        deliveries[deliveryId].verified = true;
        emit DeliveryVerified(collectorEntity, assetType);
    }

    function getDeliveryStatus(string memory treatyName, string memory assetType, string memory originCountry, string memory destinationCountry) public view returns (DeliveryEvent memory) {
        bytes32 deliveryId = keccak256(abi.encodePacked(treatyName, assetType, originCountry, destinationCountry, block.timestamp));
        return deliveries[deliveryId];
    }
}
