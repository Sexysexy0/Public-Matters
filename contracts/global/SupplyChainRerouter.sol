// SPDX-License-Identifier: TradeSanctum
pragma solidity ^0.8.19;

contract SupplyChainRerouter {
    address public steward;

    struct Shipment {
        string product;
        string origin; // e.g. "PH"
        string rerouteVia; // e.g. "EU"
        string destination; // e.g. "US"
        string corridorTag; // e.g. "Rotterdam-Houston", "Hamburg-LA"
        bool verified;
        uint256 timestamp;
    }

    Shipment[] public shipments;

    event ShipmentLogged(string product, string origin, string rerouteVia, string destination, string corridorTag, uint256 timestamp);
    event ShipmentVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logShipment(
        string memory product,
        string memory origin,
        string memory rerouteVia,
        string memory destination,
        string memory corridorTag
    ) public {
        shipments.push(Shipment(product, origin, rerouteVia, destination, corridorTag, false, block.timestamp));
        emit ShipmentLogged(product, origin, rerouteVia, destination, corridorTag, block.timestamp);
    }

    function verifyShipment(uint256 index) public {
        require(index < shipments.length, "Invalid index");
        shipments[index].verified = true;
        emit ShipmentVerified(index, msg.sender);
    }

    function getShipment(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, string memory, bool, uint256
    ) {
        Shipment memory s = shipments[index];
        return (s.product, s.origin, s.rerouteVia, s.destination, s.corridorTag, s.verified, s.timestamp);
    }

    function totalShipments() public view returns (uint256) {
        return shipments.length;
    }
}
