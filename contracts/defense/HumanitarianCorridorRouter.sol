// SPDX-License-Identifier: PeaceSanctum
pragma solidity ^0.8.19;

contract HumanitarianCorridorRouter {
    struct CorridorSignal {
        address stewardID;
        string stewardName;
        string corridorZone; // e.g., "Gaza Strip", "Northern Rafah", "Aleppo East"
        string accessType; // e.g., "Evacuation", "Medical Aid", "Food Relief"
        bool ceasefireAligned;
        bool IHLCompliant;
        string stewardNote;
    }

    mapping(address => CorridorSignal) public corridorRegistry;

    event CorridorTagged(address stewardID, string corridorZone);
    event CorridorSanctified(address stewardID);

    function tagCorridor(
        address stewardID,
        string memory stewardName,
        string memory corridorZone,
        string memory accessType,
        bool ceasefireAligned,
        bool IHLCompliant,
        string memory stewardNote
    ) public {
        corridorRegistry[stewardID] = CorridorSignal(
            stewardID,
            stewardName,
            corridorZone,
            accessType,
            ceasefireAligned,
            IHLCompliant,
            stewardNote
        );
        emit CorridorTagged(stewardID, corridorZone);
    }

    function sanctifyCorridor(address stewardID) public {
        require(bytes(corridorRegistry[stewardID].stewardName).length > 0, "Corridor not tagged");
        corridorRegistry[stewardID].IHLCompliant = true;
        emit CorridorSanctified(stewardID);
    }

    function getCorridorStatus(address stewardID) public view returns (CorridorSignal memory) {
        return corridorRegistry[stewardID];
    }
}
