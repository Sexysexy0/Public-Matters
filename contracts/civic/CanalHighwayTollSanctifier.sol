// SPDX-License-Identifier: CanalSanctum
pragma solidity ^0.8.19;

contract CanalHighwayTollSanctifier {
    struct Vessel {
        string name;
        string type;
        uint256 tonnage;
        bool tollPaid;
        uint256 tollAmount;
        bool equityTagged;
    }

    mapping(address => Vessel) public vessels;

    event VesselRegistered(address indexed steward, string name, string type, uint256 tonnage);
    event TollCalculated(address indexed steward, uint256 tollAmount);
    event TollPaid(address indexed steward);
    event EquityTagged(address indexed steward);

    function registerVessel(string memory name, string memory vesselType, uint256 tonnage) public {
        vessels[msg.sender] = Vessel(name, vesselType, tonnage, false, 0, false);
        emit VesselRegistered(msg.sender, name, vesselType, tonnage);
    }

    function calculateToll(address steward) public {
        uint256 baseRate = 3; // $3 per tonnage unit (2025 rate)
        uint256 toll = vessels[steward].tonnage * baseRate;
        vessels[steward].tollAmount = toll;
        emit TollCalculated(steward, toll);
    }

    function payToll(address steward) public {
        require(vessels[steward].tollAmount > 0, "Toll not calculated");
        vessels[steward].tollPaid = true;
        emit TollPaid(steward);
    }

    function tagEquityAccess(address steward) public {
        vessels[steward].equityTagged = true;
        emit EquityTagged(steward);
    }

    function getVesselStatus(address steward) public view returns (Vessel memory) {
        return vessels[steward];
    }
}
