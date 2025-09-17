// SPDX-License-Identifier: MercySanctum
pragma solidity ^0.8.19;

contract RefugeeSanctumRouter {
    struct SanctumSignal {
        address stewardID;
        string stewardName;
        string sanctumZone; // e.g., "Border Camp", "Urban Shelter", "Transit Corridor"
        string protectionType; // e.g., "Legal Asylum", "Medical Aid", "Food & Water"
        bool UNHCRCompliant;
        bool dignityCertified;
        string stewardNote;
    }

    mapping(address => SanctumSignal) public sanctumRegistry;

    event SanctumTagged(address stewardID, string sanctumZone);
    event SanctumSanctified(address stewardID);

    function tagSanctum(
        address stewardID,
        string memory stewardName,
        string memory sanctumZone,
        string memory protectionType,
        bool UNHCRCompliant,
        bool dignityCertified,
        string memory stewardNote
    ) public {
        sanctumRegistry[stewardID] = SanctumSignal(
            stewardID,
            stewardName,
            sanctumZone,
            protectionType,
            UNHCRCompliant,
            dignityCertified,
            stewardNote
        );
        emit SanctumTagged(stewardID, sanctumZone);
    }

    function sanctifySanctum(address stewardID) public {
        require(bytes(sanctumRegistry[stewardID].stewardName).length > 0, "Sanctum not tagged");
        sanctumRegistry[stewardID].dignityCertified = true;
        emit SanctumSanctified(stewardID);
    }

    function getSanctumStatus(address stewardID) public view returns (SanctumSignal memory) {
        return sanctumRegistry[stewardID];
    }
}
