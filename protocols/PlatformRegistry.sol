// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// PlatformRegistry: register fighter platforms and baselines
contract PlatformRegistry {
    struct Platform {
        uint256 id;
        string name;        // "Eurofighter Typhoon", "KF-21 Boramae"
        string origin;      // "Europe", "South Korea"
        string generation;  // "4.5"
        uint256 unitCost;   // USD millions
        bool active;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Platform) public platforms;
    mapping(address => bool) public stewards;

    event PlatformLogged(uint256 indexed id, string name, string origin, uint256 unitCost);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logPlatform(
        string calldata name,
        string calldata origin,
        string calldata generation,
        uint256 unitCost,
        bool active
    ) external {
        require(stewards[msg.sender], "Only steward");
        platforms[nextId] = Platform(nextId, name, origin, generation, unitCost, active, block.timestamp);
        emit PlatformLogged(nextId, name, origin, unitCost);
        nextId++;
    }

    function setActive(uint256 id, bool active) external {
        require(stewards[msg.sender], "Only steward");
        platforms[id].active = active;
    }
}
