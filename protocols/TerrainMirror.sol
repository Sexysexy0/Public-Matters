// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// TerrainMirror: record terrain challenges for extensions
contract TerrainMirror {
    struct Terrain {
        uint256 id;
        string route;
        string challenge;   // "Mountains", "Sea Crossing", "Floodplain"
        string mitigation;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Terrain) public terrains;
    mapping(address => bool) public stewards;

    event TerrainLogged(uint256 indexed id, string route, string challenge);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logTerrain(string calldata route, string calldata challenge, string calldata mitigation) external {
        require(stewards[msg.sender], "Only steward");
        terrains[nextId] = Terrain(nextId, route, challenge, mitigation, block.timestamp);
        emit TerrainLogged(nextId, route, challenge);
        nextId++;
    }
}
