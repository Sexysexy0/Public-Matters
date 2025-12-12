// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// FutureDroneGuard: record AI-enabled drone fighter development status
contract FutureDroneGuard {
    struct Drone {
        uint256 id;
        string program;     // e.g., "Skyborg"
        string status;      // "Development", "Testing", "Operational"
        uint256 readinessYear;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Drone) public drones;
    mapping(address => bool) public stewards;

    event DroneLogged(uint256 indexed id, string program, string status);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logDrone(string calldata program, string calldata status, uint256 readinessYear) external {
        require(stewards[msg.sender], "Only steward");
        drones[nextId] = Drone(nextId, program, status, readinessYear, block.timestamp);
        emit DroneLogged(nextId, program, status);
        nextId++;
    }
}
