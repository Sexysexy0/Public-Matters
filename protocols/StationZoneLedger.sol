// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// StationZoneLedger: record train station zones for redevelopment
contract StationZoneLedger {
    struct Zone {
        uint256 id;
        string station;     // "Malolos", "Clark", "Calamba"
        string location;
        bool active;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Zone) public zones;
    mapping(address => bool) public stewards;

    event ZoneLogged(uint256 indexed id, string station, string location);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logZone(string calldata station, string calldata location, bool active) external {
        require(stewards[msg.sender], "Only steward");
        zones[nextId] = Zone(nextId, station, location, active, block.timestamp);
        emit ZoneLogged(nextId, station, location);
        nextId++;
    }
}
