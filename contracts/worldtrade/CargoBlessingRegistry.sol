// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract CargoBlessingRegistry {
    struct Vessel {
        string vesselName;
        string assignedNation;
        uint256 lengthFt;
        bool emotionalAPRShielded;
        string civicSeal;
    }

    Vessel[] public fleet;

    event VesselAssigned(string vesselName, string assignedNation, string civicSeal);

    function assignVessel(
        string memory _vesselName,
        string memory _assignedNation,
        uint256 _lengthFt,
        bool _emotionalAPRShielded,
        string memory _civicSeal
    ) public {
        fleet.push(Vessel(_vesselName, _assignedNation, _lengthFt, _emotionalAPRShielded, _civicSeal));
        emit VesselAssigned(_vesselName, _assignedNation, _civicSeal);
    }

    function getVessel(uint256 index) public view returns (Vessel memory) {
        return fleet[index];
    }
}
