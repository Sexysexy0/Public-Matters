// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Party-List Reform: Registry + Sector mapping
contract PartyListRegistry {
    struct Sector {
        uint256 id;
        string name;      // e.g., "Workers", "Farmers", "IP/Indigenous", "Women", "Youth", "PWD", "Seniors"
        bool active;
    }

    struct Party {
        uint256 id;
        string name;
        uint256 sectorId;
        bool active;
    }

    address public steward;
    uint256 public nextSectorId;
    uint256 public nextPartyId;

    mapping(uint256 => Sector) public sectors;
    mapping(uint256 => Party) public parties;
    mapping(string => bool) private sectorNameTaken;
    mapping(string => bool) private partyNameTaken;

    event SectorAdded(uint256 indexed id, string name);
    event SectorToggled(uint256 indexed id, bool active);
    event PartyAdded(uint256 indexed id, string name, uint256 sectorId);
    event PartyToggled(uint256 indexed id, bool active);

    constructor() {
        steward = msg.sender;
    }

    function addSector(string calldata _name) external {
        require(msg.sender == steward, "Only steward");
        require(!sectorNameTaken[_name], "Sector exists");
        sectors[nextSectorId] = Sector(nextSectorId, _name, true);
        sectorNameTaken[_name] = true;
        emit SectorAdded(nextSectorId, _name);
        nextSectorId++;
    }

    function toggleSector(uint256 _id, bool _active) external {
        require(msg.sender == steward, "Only steward");
        sectors[_id].active = _active;
        emit SectorToggled(_id, _active);
    }

    function addParty(string calldata _name, uint256 _sectorId) external {
        require(msg.sender == steward, "Only steward");
        require(sectors[_sectorId].active, "Sector inactive");
        require(!partyNameTaken[_name], "Party exists");
        parties[nextPartyId] = Party(nextPartyId, _name, _sectorId, true);
        partyNameTaken[_name] = true;
        emit PartyAdded(nextPartyId, _name, _sectorId);
        nextPartyId++;
    }

    function toggleParty(uint256 _id, bool _active) external {
        require(msg.sender == steward, "Only steward");
        parties[_id].active = _active;
        emit PartyToggled(_id, _active);
    }
}
