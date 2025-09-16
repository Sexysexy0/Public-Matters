// SPDX-License-Identifier: FoodTechSanctum
pragma solidity ^0.8.19;

contract FoodTechCorridorBlessingRouter {
    struct CorridorSignal {
        string corridorName;
        string commodityType;
        bool blessed;
        string stewardNote;
    }

    mapping(string => CorridorSignal) public corridorRegistry;

    event CorridorTagged(string corridorName, string commodityType);
    event CorridorBlessed(string corridorName);

    function tagCorridor(string memory corridorName, string memory commodityType, string memory stewardNote) public {
        corridorRegistry[corridorName] = CorridorSignal(corridorName, commodityType, false, stewardNote);
        emit CorridorTagged(corridorName, commodityType);
    }

    function blessCorridor(string memory corridorName) public {
        require(bytes(corridorRegistry[corridorName].commodityType).length > 0, "Corridor not tagged");
        corridorRegistry[corridorName].blessed = true;
        emit CorridorBlessed(corridorName);
    }

    function getCorridorStatus(string memory corridorName) public view returns (CorridorSignal memory) {
        return corridorRegistry[corridorName];
    }
}
