// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PlanetaryBlessingIndex {
    enum BlessingType { Artifact, Protocol, Treaty, Ledger }
    enum SanctumZone { Natlan, Malolos, Bangkal, Mindoro }

    struct BlessingEntry {
        uint256 id;
        BlessingType blessingType;
        SanctumZone zone;
        string sanctumName;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => BlessingEntry) public blessingRegistry;
    uint256 public blessingCount;

    event BlessingLogged(uint256 id, BlessingType blessingType, SanctumZone zone);
    event ZoneUpdated(uint256 id, SanctumZone newZone);

    function logBlessing(
        BlessingType blessingType,
        SanctumZone zone,
        string memory sanctumName,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        blessingRegistry[blessingCount] = BlessingEntry(
            blessingCount,
            blessingType,
            zone,
            sanctumName,
            clauseReference,
            timestamp
        );
        emit BlessingLogged(blessingCount, blessingType, zone);
        blessingCount++;
    }

    function updateZone(uint256 id, SanctumZone newZone) public {
        require(id < blessingCount, "Invalid blessing ID");
        blessingRegistry[id].zone = newZone;
        emit ZoneUpdated(id, newZone);
    }

    function getBlessingEntry(uint256 id) public view returns (BlessingEntry memory) {
        return blessingRegistry[id];
    }
}
