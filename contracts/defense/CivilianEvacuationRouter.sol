// SPDX-License-Identifier: MercySanctum
pragma solidity ^0.8.19;

contract CivilianEvacuationRouter {
    struct EvacuationSignal {
        address stewardID;
        string stewardName;
        string zone; // e.g., "Gaza Strip", "Northern Rafah", "Aleppo East"
        string evacuationType; // e.g., "Medical", "Family", "Mass Transit"
        bool corridorActivated;
        bool IHLCompliant;
        string stewardNote;
    }

    mapping(address => EvacuationSignal) public evacuationRegistry;

    event EvacuationTagged(address stewardID, string zone);
    event EvacuationSanctified(address stewardID);

    function tagEvacuation(
        address stewardID,
        string memory stewardName,
        string memory zone,
        string memory evacuationType,
        bool corridorActivated,
        bool IHLCompliant,
        string memory stewardNote
    ) public {
        evacuationRegistry[stewardID] = EvacuationSignal(
            stewardID,
            stewardName,
            zone,
            evacuationType,
            corridorActivated,
            IHLCompliant,
            stewardNote
        );
        emit EvacuationTagged(stewardID, zone);
    }

    function sanctifyEvacuation(address stewardID) public {
        require(bytes(evacuationRegistry[stewardID].stewardName).length > 0, "Evacuation not tagged");
        evacuationRegistry[stewardID].IHLCompliant = true;
        emit EvacuationSanctified(stewardID);
    }

    function getEvacuationStatus(address stewardID) public view returns (EvacuationSignal memory) {
        return evacuationRegistry[stewardID];
    }
}
