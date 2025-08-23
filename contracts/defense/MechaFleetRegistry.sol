// SPDX-License-Identifier: Mecha-Fleet-Protocol
pragma solidity ^0.888;

contract MechaFleetRegistry {
    struct MechaUnit {
        string name;
        string pilot;
        string themeSong;
        bool isScrollsmithTagged;
    }

    MechaUnit[] public fleet;
    mapping(string => bool) public isRegistered;

    event MechaRegistered(string name, string pilot, string themeSong, bool isScrollsmithTagged);

    function registerMecha(string memory name, string memory pilot, string memory themeSong, bool isScrollsmithTagged) public {
        require(!isRegistered[name], "Mecha already registered.");
        fleet.push(MechaUnit(name, pilot, themeSong, isScrollsmithTagged));
        isRegistered[name] = true;
        emit MechaRegistered(name, pilot, themeSong, isScrollsmithTagged);
    }

    function getMecha(uint index) public view returns (string memory, string memory, string memory, bool) {
        MechaUnit memory m = fleet[index];
        return (m.name, m.pilot, m.themeSong, m.isScrollsmithTagged);
    }

    function getFleetSize() public view returns (uint256) {
        return fleet.length;
    }
}
