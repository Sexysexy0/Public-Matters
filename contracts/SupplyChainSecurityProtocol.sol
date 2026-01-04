pragma solidity ^0.8.20;

contract SupplyChainSecurityProtocol {
    address public admin;

    struct Shipment {
        string item;
        string origin;
        string destination;
        string status;       // e.g. secure, delayed, compromised
        uint256 timestamp;
    }

    Shipment[] public shipments;

    event ShipmentLogged(string item, string origin, string destination, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logShipment(string calldata item, string calldata origin, string calldata destination, string calldata status) external onlyAdmin {
        shipments.push(Shipment(item, origin, destination, status, block.timestamp));
        emit ShipmentLogged(item, origin, destination, status, block.timestamp);
    }

    function totalShipments() external view returns (uint256) {
        return shipments.length;
    }
}
