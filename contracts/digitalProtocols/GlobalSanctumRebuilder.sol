// SPDX-License-Identifier: RebuilderSanctum
pragma solidity ^0.8.19;

contract GlobalSanctumRebuilder {
    struct RebuildSignal {
        address stewardID;
        string stewardName;
        string sanctumZone; // e.g., "Digital Corridor", "Climate Refuge", "Civic Hub"
        string restorationType; // e.g., "Infrastructure", "Emotional Equity", "Covenant Renewal"
        bool restorationDeployed;
        bool equityCertified;
        string stewardNote;
    }

    mapping(address => RebuildSignal) public rebuildRegistry;

    event SanctumTagged(address stewardID, string sanctumZone);
    event SanctumRebuilt(address stewardID);

    function tagSanctum(
        address stewardID,
        string memory stewardName,
        string memory sanctumZone,
        string memory restorationType,
        bool restorationDeployed,
        bool equityCertified,
        string memory stewardNote
    ) public {
        rebuildRegistry[stewardID] = RebuildSignal(
            stewardID,
            stewardName,
            sanctumZone,
            restorationType,
            restorationDeployed,
            equityCertified,
            stewardNote
        );
        emit SanctumTagged(stewardID, sanctumZone);
    }

    function sanctifyRebuild(address stewardID) public {
        require(bytes(rebuildRegistry[stewardID].stewardName).length > 0, "Sanctum not tagged");
        rebuildRegistry[stewardID].equityCertified = true;
        emit SanctumRebuilt(stewardID);
    }

    function getRebuildStatus(address stewardID) public view returns (RebuildSignal memory) {
        return rebuildRegistry[stewardID];
    }
}
