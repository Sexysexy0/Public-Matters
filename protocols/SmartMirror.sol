// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SmartMirror: record smart checkpoint deployments (tech-enabled)
contract SmartMirror {
    struct SmartCheckpoint {
        uint256 id;
        string location;
        string tech;        // "RFID", "Plate Recognition", "CCTV"
        string purpose;     // "Anti-smuggling", "Traffic Monitoring"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => SmartCheckpoint) public smartCheckpoints;
    mapping(address => bool) public stewards;

    event SmartCheckpointLogged(uint256 indexed id, string location, string tech);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logSmartCheckpoint(string calldata location, string calldata tech, string calldata purpose) external {
        require(stewards[msg.sender], "Only steward");
        smartCheckpoints[nextId] = SmartCheckpoint(nextId, location, tech, purpose, block.timestamp);
        emit SmartCheckpointLogged(nextId, location, tech);
        nextId++;
    }
}
