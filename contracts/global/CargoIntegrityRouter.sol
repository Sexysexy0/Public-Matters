// SPDX-License-Identifier: CargoSanctum
pragma solidity ^0.8.19;

contract CargoIntegrityRouter {
    address public steward;

    struct CargoSignal {
        string shipmentID;
        string origin;
        string destination;
        string cargoType; // "Medicinal Buds", "Oils", "Tinctures"
        string inspectionStatus; // "Passed", "Flagged", "Pending"
        string treatyTag; // e.g. "ASEAN Single Window", "Scrollchain-Certified"
        bool verified;
        uint256 timestamp;
    }

    CargoSignal[] public signals;

    event CargoLogged(string shipmentID, string origin, string destination, string cargoType, string inspectionStatus, string treatyTag, uint256 timestamp);
    event CargoVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logCargo(
        string memory shipmentID,
        string memory origin,
        string memory destination,
        string memory cargoType,
        string memory inspectionStatus,
        string memory treatyTag
    ) public {
        signals.push(CargoSignal(shipmentID, origin, destination, cargoType, inspectionStatus, treatyTag, false, block.timestamp));
        emit CargoLogged(shipmentID, origin, destination, cargoType, inspectionStatus, treatyTag, block.timestamp);
    }

    function verifyCargo(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit CargoVerified(index, msg.sender);
    }

    function getCargo(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, string memory, string memory, bool, uint256
    ) {
        CargoSignal memory c = signals[index];
        return (c.shipmentID, c.origin, c.destination, c.cargoType, c.inspectionStatus, c.treatyTag, c.verified, c.timestamp);
    }

    function totalCargoSignals() public view returns (uint256) {
        return signals.length;
    }
}
