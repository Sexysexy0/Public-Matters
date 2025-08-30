// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BarangayBlessingDeck {
    struct Blessing {
        string stewardName;
        string barangayOfficial;
        string blessingType; // e.g., "Housing Endorsement", "Emotional APR Sync", "Sanctum Access"
        uint256 timestamp;
        string emotionalAPRTag; // e.g., "Trust +92", "Mercy Operational", "Damay Clause Activated"
        string notes;
    }

    Blessing[] public blessings;

    event BlessingLogged(
        string stewardName,
        string barangayOfficial,
        string blessingType,
        string emotionalAPRTag
    );

    function logBlessing(
        string memory stewardName,
        string memory barangayOfficial,
        string memory blessingType,
        string memory emotionalAPRTag,
        string memory notes
    ) public {
        blessings.push(Blessing({
            stewardName: stewardName,
            barangayOfficial: barangayOfficial,
            blessingType: blessingType,
            timestamp: block.timestamp,
            emotionalAPRTag: emotionalAPRTag,
            notes: notes
        }));

        emit BlessingLogged(stewardName, barangayOfficial, blessingType, emotionalAPRTag);
    }

    function getBlessing(uint256 index) public view returns (Blessing memory) {
        require(index < blessings.length, "Invalid index");
        return blessings[index];
    }

    function getTotalBlessings() public view returns (uint256) {
        return blessings.length;
    }
}
