// OrbitalTrafficRegistry.sol
pragma solidity ^0.8.0;

contract OrbitalTrafficRegistry {
    struct Satellite {
        string owner;
        uint256 launchDate;
        bool isActive;
        uint256 orbitalRentOwed;
    }

    mapping(string => Satellite) public orbitalMap;

    function registerSatellite(string memory _satID, string memory _owner) public {
        orbitalMap[_satID] = Satellite(_owner, block.timestamp, true, 0);
    }

    function calculateRent(string memory _satID, uint256 _hoursOverTerritory) public {
        // Rent = 100 PHP per hour over sovereign space
        orbitalMap[_satID].orbitalRentOwed += (_hoursOverTerritory * 100);
    }
}
