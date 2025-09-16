// SPDX-License-Identifier: CargoSanctum
pragma solidity ^0.8.19;

contract CargoIntegrityBlessingRouter {
    struct CargoSignal {
        string shipmentID;
        string origin;
        string destination;
        bool verified;
        string stewardNote;
    }

    mapping(string => CargoSignal) public cargoRegistry;

    event CargoTagged(string shipmentID, string origin, string destination);
    event CargoBlessed(string shipmentID);

    function tagCargo(string memory shipmentID, string memory origin, string memory destination, string memory stewardNote) public {
        cargoRegistry[shipmentID] = CargoSignal(shipmentID, origin, destination, false, stewardNote);
        emit CargoTagged(shipmentID, origin, destination);
    }

    function blessCargo(string memory shipmentID) public {
        require(bytes(cargoRegistry[shipmentID].origin).length > 0, "Cargo not tagged");
        cargoRegistry[shipmentID].verified = true;
        emit CargoBlessed(shipmentID);
    }

    function getCargoStatus(string memory shipmentID) public view returns (CargoSignal memory) {
        return cargoRegistry[shipmentID];
    }
}
