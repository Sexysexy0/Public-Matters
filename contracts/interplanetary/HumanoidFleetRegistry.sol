// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HumanoidFleetRegistry {
    struct Humanoid {
        uint256 id;
        string designation;
        string role;
        string zoneAssigned;
        bool active;
        uint256 timestamp;
    }

    mapping(uint256 => Humanoid) public fleet;
    uint256 public fleetCount;

    event HumanoidDeployed(uint256 id, string role);

    function deployHumanoid(
        string memory designation,
        string memory role,
        string memory zoneAssigned,
        uint256 timestamp
    ) public {
        fleet[fleetCount] = Humanoid(
            fleetCount, designation, role, zoneAssigned, true, timestamp
        );
        emit HumanoidDeployed(fleetCount, role);
        fleetCount++;
    }

    function deactivateHumanoid(uint256 id) public {
        fleet[id].active = false;
    }

    function getHumanoid(uint256 id) public view returns (Humanoid memory) {
        return fleet[id];
    }
}
