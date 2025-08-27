// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.27;

contract KinderFleetDefenseContract {
    address public steward;
    uint256 public fleetCount;
    mapping(uint256 => Vessel) public fleetRegistry;

    struct Vessel {
        string name;
        string classType;
        bool ultraMagneticShield;
        bool emotionalAPRScanner;
        bool damayClauseActivated;
    }

    event VesselDeployed(string name, string classType, bool shielded, bool emotionallyTagged);

    constructor() {
        steward = msg.sender;
        fleetCount = 0;
    }

    function deployVessel(
        string memory _name,
        string memory _classType,
        bool _ultraMagneticShield,
        bool _emotionalAPRScanner
    ) public {
        require(msg.sender == steward, "Only scroll-certified steward may deploy.");
        fleetRegistry[fleetCount] = Vessel(
            _name,
            _classType,
            _ultraMagneticShield,
            _emotionalAPRScanner,
            true // Damay clause always activated
        );
        emit VesselDeployed(_name, _classType, _ultraMagneticShield, _emotionalAPRScanner);
        fleetCount++;
    }

    function getVessel(uint256 _id) public view returns (Vessel memory) {
        return fleetRegistry[_id];
    }
}
