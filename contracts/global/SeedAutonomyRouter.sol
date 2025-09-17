// SPDX-License-Identifier: SeedSanctum
pragma solidity ^0.8.19;

contract SeedAutonomyRouter {
    struct SeedBlessing {
        address stewardID;
        string stewardName;
        string seedType; // e.g., "Heirloom Rice", "Medicinal Herbs", "Climate-Resilient Maize"
        bool openPollinated;
        bool sovereigntyCertified;
        string stewardNote;
    }

    mapping(address => SeedBlessing) public seedRegistry;

    event SeedTagged(address stewardID, string seedType);
    event SovereigntyCertified(address stewardID);

    function tagSeed(
        address stewardID,
        string memory stewardName,
        string memory seedType,
        bool openPollinated,
        bool sovereigntyCertified,
        string memory stewardNote
    ) public {
        seedRegistry[stewardID] = SeedBlessing(
            stewardID,
            stewardName,
            seedType,
            openPollinated,
            sovereigntyCertified,
            stewardNote
        );
        emit SeedTagged(stewardID, seedType);
    }

    function certifySovereignty(address stewardID) public {
        require(bytes(seedRegistry[stewardID].stewardName).length > 0, "Seed not tagged");
        seedRegistry[stewardID].sovereigntyCertified = true;
        emit SovereigntyCertified(stewardID);
    }

    function getSeedStatus(address stewardID) public view returns (SeedBlessing memory) {
        return seedRegistry[stewardID];
    }
}
