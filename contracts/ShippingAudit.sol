// contracts/ShippingAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ShippingAudit
 * @notice Tracks shipping flows and communal audit of maritime trade.
 */
contract ShippingAudit {
    address public admin;

    struct Shipment {
        string origin;
        string destination;
        string cargo;       // "Oil", "Food", "Electronics"
        uint256 volume;     // in metric tons
        uint256 timestamp;
    }

    Shipment[] public shipments;

    event ShipmentLogged(string origin, string destination, string cargo, uint256 volume, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logShipment(string calldata origin, string calldata destination, string calldata cargo, uint256 volume) external onlyAdmin {
        shipments.push(Shipment(origin, destination, cargo, volume, block.timestamp));
        emit ShipmentLogged(origin, destination, cargo, volume, block.timestamp);
    }

    function totalShipments() external view returns (uint256) { return shipments.length; }

    function getShipment(uint256 id) external view returns (Shipment memory) {
        require(id < shipments.length, "Invalid id");
        return shipments[id];
    }
}
