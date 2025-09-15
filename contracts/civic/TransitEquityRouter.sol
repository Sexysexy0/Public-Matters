// SPDX-License-Identifier: BlessingSanctum
pragma solidity ^0.8.19;

contract TransitEquityRouter {
    struct Vessel {
        string name;
        string type;
        uint256 tonnage;
        bool equityTagged;
        uint256 tollAmount;
    }

    mapping(address => Vessel) public vessels;

    event VesselRegistered(address indexed steward, string name, string type, uint256 tonnage);
    event EquityTagged(address indexed steward);
    event TollCalculated(address indexed steward, uint256 tollAmount);

    function registerVessel(string memory name, string memory vesselType, uint256 tonnage) public {
        vessels[msg.sender] = Vessel(name, vesselType, tonnage, false, 0);
        emit VesselRegistered(msg.sender, name, vesselType, tonnage);
    }

    function tagEquityAccess(address steward) public {
        vessels[steward].equityTagged = true;
        emit EquityTagged(steward);
    }

    function calculateToll(address steward) public {
        uint256 baseRate = 3;
        uint256 discount = vessels[steward].equityTagged ? 20 : 0;
        uint256 toll = (vessels[steward].tonnage * baseRate * (100 - discount)) / 100;
        vessels[steward].tollAmount = toll;
        emit TollCalculated(steward, toll);
    }

    function getToll(address steward) public view returns (uint256) {
        return vessels[steward].tollAmount;
    }
}
