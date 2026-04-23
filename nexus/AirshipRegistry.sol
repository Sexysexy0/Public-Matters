// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AirshipRegistry {
    struct Airship {
        string shipName;
        uint256 weightClass; // Light, Medium, Heavy (Galleon)
        bytes32 blueprintHash; // Data signature of the ship design
    }

    mapping(address => Airship) public fleetRegistry;

    function registerShip(string memory _name, uint256 _weight, bytes32 _hash) external {
        fleetRegistry[msg.sender] = Airship(_name, _weight, _hash);
    }
}
