// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BlessedShelterContract {
    struct Shelter {
        address steward;
        string location;
        uint256 monthlyBlessing;
        uint256 emotionalAPR;
        bool evictionOverride;
        bool active;
    }

    Shelter[] public shelters;

    event ShelterBlessed(address steward, string location, uint256 monthlyBlessing, uint256 emotionalAPR);
    event EvictionOverridden(address steward, string location);

    function blessShelter(
        address _steward,
        string memory _location,
        uint256 _monthlyBlessing,
        uint256 _emotionalAPR
    ) public {
        shelters.push(Shelter(_steward, _location, _monthlyBlessing, _emotionalAPR, false, true));
        emit ShelterBlessed(_steward, _location, _monthlyBlessing, _emotionalAPR);
    }

    function overrideEviction(uint256 _index) public {
        require(_index < shelters.length, "Invalid index");
        Shelter storage s = shelters[_index];
        require(msg.sender == s.steward, "Not steward");
        s.evictionOverride = true;
        emit EvictionOverridden(s.steward, s.location);
    }

    function getAllShelters() public view returns (Shelter[] memory) {
        return shelters;
    }
}
