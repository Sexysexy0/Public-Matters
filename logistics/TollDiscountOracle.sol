// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VehicleFleetRegistry {
    enum VehicleType { Truck, Bus, Van, Jeepney }
    struct Vehicle { VehicleType vType; bool isEssential; address owner; }
    mapping(string => Vehicle) public fleet;

    function registerVehicle(string memory _plate, VehicleType _type) external {
        fleet[_plate] = Vehicle(_type, true, msg.sender);
        // SYNC: Vehicle tagged for 80% Industrial Subsidy.
    }
}
