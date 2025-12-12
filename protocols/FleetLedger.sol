// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// FleetLedger: record current fighter fleet composition
contract FleetLedger {
    struct Fighter {
        uint256 id;
        string model;       // e.g., "F-22", "F-35", "F-16"
        string generation;  // "5th gen", "Cold War"
        uint256 count;
        uint256 serviceLife; // years remaining
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Fighter) public fighters;
    mapping(address => bool) public stewards;

    event FighterLogged(uint256 indexed id, string model, uint256 count);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logFighter(string calldata model, string calldata generation, uint256 count, uint256 serviceLife) external {
        require(stewards[msg.sender], "Only steward");
        fighters[nextId] = Fighter(nextId, model, generation, count, serviceLife, block.timestamp);
        emit FighterLogged(nextId, model, count);
        nextId++;
    }
}
