// SPDX-License-Identifier: DisplacementSanctum
pragma solidity ^0.8.19;

contract DisplacementEquityRouter {
    struct TransitSignal {
        string corridorID;
        string originCountry;
        string hostCountry;
        uint256 aidAmountUSD;
        bool blessed;
        string stewardNote;
    }

    mapping(string => TransitSignal) public transitRegistry;

    event CorridorTagged(string corridorID, string originCountry, string hostCountry);
    event EquityBlessed(string corridorID);

    function tagCorridor(string memory corridorID, string memory originCountry, string memory hostCountry, uint256 aidAmountUSD, string memory stewardNote) public {
        transitRegistry[corridorID] = TransitSignal(corridorID, originCountry, hostCountry, aidAmountUSD, false, stewardNote);
        emit CorridorTagged(corridorID, originCountry, hostCountry);
    }

    function blessEquity(string memory corridorID) public {
        require(transitRegistry[corridorID].aidAmountUSD > 0, "Corridor not tagged");
        transitRegistry[corridorID].blessed = true;
        emit EquityBlessed(corridorID);
    }

    function getTransitStatus(string memory corridorID) public view returns (TransitSignal memory) {
        return transitRegistry[corridorID];
    }
}
