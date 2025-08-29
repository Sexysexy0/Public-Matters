// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract SectoralBlessingDeck {
    address public steward;

    enum Sector { Infra, Agri, Power, Health, Education, Transport }

    struct Blessing {
        string contractor;
        Sector sector;
        bool emotionallyAligned;
        bool technicallyQualified;
        uint256 timestamp;
    }

    Blessing[] public blessings;

    event SectorBlessingGranted(string contractor, Sector sector);

    constructor() {
        steward = msg.sender;
    }

    function grantBlessing(
        string memory contractor,
        Sector sector,
        bool emotionallyAligned,
        bool technicallyQualified
    ) public {
        blessings.push(Blessing(contractor, sector, emotionallyAligned, technicallyQualified, block.timestamp));
        emit SectorBlessingGranted(contractor, sector);
    }

    function getBlessing(uint256 index) public view returns (Blessing memory) {
        return blessings[index];
    }

    function totalBlessings() public view returns (uint256) {
        return blessings.length;
    }
}
