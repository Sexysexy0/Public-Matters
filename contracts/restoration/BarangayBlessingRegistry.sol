// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract BarangayBlessingRegistry {
    struct Blessing {
        string barangayName;
        string steward;
        string gridType; // e.g., "SolarGrid", "WindGrid", "HydroGrid"
        bool civicConsent;
        uint256 emotionalAPR; // scale 0–100
        string mythicTag; // e.g., "DamayCertified", "KinderBlessed"
        uint256 timestamp;
    }

    Blessing[] public blessings;

    event BarangayBlessed(
        string barangayName,
        string steward,
        string gridType,
        bool civicConsent,
        uint256 emotionalAPR,
        string mythicTag
    );

    function blessBarangay(
        string memory barangayName,
        string memory steward,
        string memory gridType,
        bool civicConsent,
        uint256 emotionalAPR,
        string memory mythicTag
    ) public {
        blessings.push(Blessing(barangayName, steward, gridType, civicConsent, emotionalAPR, mythicTag, block.timestamp));
        emit BarangayBlessed(barangayName, steward, gridType, civicConsent, emotionalAPR, mythicTag);
    }

    function getBlessing(uint index) public view returns (
        string memory, string memory, string memory, bool, uint256, string memory, uint256
    ) {
        Blessing memory b = blessings[index];
        return (
            b.barangayName,
            b.steward,
            b.gridType,
            b.civicConsent,
            b.emotionalAPR,
            b.mythicTag,
            b.timestamp
        );
    }

    function totalBlessings() public view returns (uint256) {
        return blessings.length;
    }
}
