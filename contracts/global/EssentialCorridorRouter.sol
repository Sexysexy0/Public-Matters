// SPDX-License-Identifier: HumanitarianSanctum
pragma solidity ^0.8.19;

contract EssentialCorridorRouter {
    struct CorridorBlessing {
        address corridorID;
        string originCountry;
        string destinationCountry;
        string commodityType; // e.g., "Fruits", "Grains", "Medicine"
        bool tariffExempt;
        bool dignityCertified;
        string stewardNote;
    }

    mapping(address => CorridorBlessing) public corridorRegistry;

    event CorridorTagged(address corridorID, string commodityType);
    event CorridorSanctified(address corridorID);

    function tagCorridor(
        address corridorID,
        string memory originCountry,
        string memory destinationCountry,
        string memory commodityType,
        bool tariffExempt,
        bool dignityCertified,
        string memory stewardNote
    ) public {
        corridorRegistry[corridorID] = CorridorBlessing(
            corridorID,
            originCountry,
            destinationCountry,
            commodityType,
            tariffExempt,
            dignityCertified,
            stewardNote
        );
        emit CorridorTagged(corridorID, commodityType);
    }

    function sanctifyCorridor(address corridorID) public {
        require(bytes(corridorRegistry[corridorID].originCountry).length > 0, "Corridor not tagged");
        corridorRegistry[corridorID].dignityCertified = true;
        emit CorridorSanctified(corridorID);
    }

    function getCorridorStatus(address corridorID) public view returns (CorridorBlessing memory) {
        return corridorRegistry[corridorID];
    }
}
