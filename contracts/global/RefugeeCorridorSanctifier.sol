// SPDX-License-Identifier: RefugeeSanctum
pragma solidity ^0.8.19;

contract RefugeeCorridorSanctifier {
    struct CorridorSignal {
        string corridorID;
        string originCountry;
        string hostCountry;
        bool blessed;
        string stewardNote;
    }

    mapping(string => CorridorSignal) public corridorRegistry;

    event CorridorTagged(string corridorID, string originCountry, string hostCountry);
    event CorridorBlessed(string corridorID);

    function tagCorridor(string memory corridorID, string memory originCountry, string memory hostCountry, string memory stewardNote) public {
        corridorRegistry[corridorID] = CorridorSignal(corridorID, originCountry, hostCountry, false, stewardNote);
        emit CorridorTagged(corridorID, originCountry, hostCountry);
    }

    function blessCorridor(string memory corridorID) public {
        require(bytes(corridorRegistry[corridorID].originCountry).length > 0, "Corridor not tagged");
        corridorRegistry[corridorID].blessed = true;
        emit CorridorBlessed(corridorID);
    }

    function getCorridorStatus(string memory corridorID) public view returns (CorridorSignal memory) {
        return corridorRegistry[corridorID];
    }
}
