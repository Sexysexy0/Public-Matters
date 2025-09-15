// SPDX-License-Identifier: CustodySanctum
pragma solidity ^0.8.19;

contract AssetCustodyBeacon {
    struct CustodyEvent {
        string assetType; // e.g., "Gold", "Grain", "Machinery"
        string originCountry;
        string destinationCountry;
        string collectorEntity;
        uint256 quantity;
        bool received;
        bool verified;
        string custodyNote;
    }

    mapping(bytes32 => CustodyEvent) public events;

    event CustodyTagged(string assetType, string originCountry, string destinationCountry);
    event CustodyVerified(string collectorEntity, string assetType);

    function tagCustody(string memory assetType, string memory originCountry, string memory destinationCountry, string memory collectorEntity, uint256 quantity, string memory custodyNote) public {
        bytes32 eventId = keccak256(abi.encodePacked(assetType, originCountry, destinationCountry, block.timestamp));
        events[eventId] = CustodyEvent(assetType, originCountry, destinationCountry, collectorEntity, quantity, false, false, custodyNote);
        emit CustodyTagged(assetType, originCountry, destinationCountry);
    }

    function verifyCustody(string memory assetType, string memory originCountry, string memory destinationCountry, string memory collectorEntity) public {
        bytes32 eventId = keccak256(abi.encodePacked(assetType, originCountry, destinationCountry, block.timestamp));
        events[eventId].received = true;
        events[eventId].verified = true;
        emit CustodyVerified(collectorEntity, assetType);
    }

    function getCustodyStatus(string memory assetType, string memory originCountry, string memory destinationCountry) public view returns (CustodyEvent memory) {
        bytes32 eventId = keccak256(abi.encodePacked(assetType, originCountry, destinationCountry, block.timestamp));
        return events[eventId];
    }
}
