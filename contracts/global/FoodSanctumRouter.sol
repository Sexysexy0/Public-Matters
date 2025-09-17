// SPDX-License-Identifier: NourishmentSanctum
pragma solidity ^0.8.19;

contract FoodSanctumRouter {
    struct SanctumSignal {
        address stewardID;
        string stewardName;
        string foodType; // e.g., "Root Crops", "Medicinal Herbs", "Grains"
        string sanctumZone; // e.g., "Ancestral Domain", "Urban Corridor", "Disaster Region"
        uint256 volumeInKg;
        bool dignityCertified;
        string stewardNote;
    }

    mapping(address => SanctumSignal) public sanctumRegistry;

    event SanctumTagged(address stewardID, string foodType);
    event SanctumActivated(address stewardID);

    function tagSanctum(
        address stewardID,
        string memory stewardName,
        string memory foodType,
        string memory sanctumZone,
        uint256 volumeInKg,
        bool dignityCertified,
        string memory stewardNote
    ) public {
        sanctumRegistry[stewardID] = SanctumSignal(
            stewardID,
            stewardName,
            foodType,
            sanctumZone,
            volumeInKg,
            dignityCertified,
            stewardNote
        );
        emit SanctumTagged(stewardID, foodType);
    }

    function activateSanctum(address stewardID) public {
        require(bytes(sanctumRegistry[stewardID].stewardName).length > 0, "Sanctum not tagged");
        sanctumRegistry[stewardID].dignityCertified = true;
        emit SanctumActivated(stewardID);
    }

    function getSanctumStatus(address stewardID) public view returns (SanctumSignal memory) {
        return sanctumRegistry[stewardID];
    }
}
