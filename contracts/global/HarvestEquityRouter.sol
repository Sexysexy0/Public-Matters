// SPDX-License-Identifier: HarvestSanctum
pragma solidity ^0.8.19;

contract HarvestEquityRouter {
    struct HarvestBlessing {
        address stewardID;
        string stewardName;
        string cropType; // e.g., "Rice", "Cassava", "Medicinal Herbs"
        uint256 harvestVolume;
        bool dignityCertified;
        string stewardNote;
    }

    mapping(address => HarvestBlessing) public harvestRegistry;

    event HarvestTagged(address stewardID, string cropType);
    event EquityCertified(address stewardID);

    function tagHarvest(
        address stewardID,
        string memory stewardName,
        string memory cropType,
        uint256 harvestVolume,
        bool dignityCertified,
        string memory stewardNote
    ) public {
        harvestRegistry[stewardID] = HarvestBlessing(
            stewardID,
            stewardName,
            cropType,
            harvestVolume,
            dignityCertified,
            stewardNote
        );
        emit HarvestTagged(stewardID, cropType);
    }

    function certifyEquity(address stewardID) public {
        require(bytes(harvestRegistry[stewardID].stewardName).length > 0, "Harvest not tagged");
        harvestRegistry[stewardID].dignityCertified = true;
        emit EquityCertified(stewardID);
    }

    function getHarvestStatus(address stewardID) public view returns (HarvestBlessing memory) {
        return harvestRegistry[stewardID];
    }
}
