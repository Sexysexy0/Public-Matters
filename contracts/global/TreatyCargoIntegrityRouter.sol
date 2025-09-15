// SPDX-License-Identifier: CargoSanctum
pragma solidity ^0.8.19;

contract TreatyCargoIntegrityRouter {
    struct CargoEvent {
        string treatyName;
        string assetType; // e.g., "Gold", "Grain", "Oil", "Medical Supplies"
        string originCountry;
        string destinationCountry;
        string inspectorEntity;
        uint256 quantity;
        bool inspected;
        bool verified;
        string integrityNote;
    }

    mapping(bytes32 => CargoEvent) public events;

    event CargoTagged(string treatyName, string assetType, string originCountry, string destinationCountry);
    event CargoVerified(string inspectorEntity, string assetType);

    function tagCargo(string memory treatyName, string memory assetType, string memory originCountry, string memory destinationCountry, string memory inspectorEntity, uint256 quantity, string memory integrityNote) public {
        bytes32 cargoId = keccak256(abi.encodePacked(treatyName, assetType, originCountry, destinationCountry, block.timestamp));
        events[cargoId] = CargoEvent(treatyName, assetType, originCountry, destinationCountry, inspectorEntity, quantity, false, false, integrityNote);
        emit CargoTagged(treatyName, assetType, originCountry, destinationCountry);
    }

    function verifyCargo(string memory treatyName, string memory assetType, string memory originCountry, string memory destinationCountry, string memory inspectorEntity) public {
        bytes32 cargoId = keccak256(abi.encodePacked(treatyName, assetType, originCountry, destinationCountry, block.timestamp));
        events[cargoId].inspected = true;
        events[cargoId].verified = true;
        emit CargoVerified(inspectorEntity, assetType);
    }

    function getCargoStatus(string memory treatyName, string memory assetType, string memory originCountry, string memory destinationCountry) public view returns (CargoEvent memory) {
        bytes32 cargoId = keccak256(abi.encodePacked(treatyName, assetType, originCountry, destinationCountry, block.timestamp));
        return events[cargoId];
    }
}
